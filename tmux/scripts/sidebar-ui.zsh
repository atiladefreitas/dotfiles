#!/bin/zsh
# Session sidebar: every tmux session with its dev servers and AI agents.
# sidebar.sh runs one copy in the left pane of each window. Reach it with C-h
# or a click; the footer lists the keys for the selected row, ? shows them all
# and / finds a session by name.
#
# Besides tmux's own formats it reads the @git_dirty session option
# (session-git.sh: uncommitted changes, shown in orange) and two pane options:
#   @pane_port    ports a node server in that pane listens on (session-port.sh,
#                 rerun every few seconds by whichever sidebar is on screen)
#   @agent_state  working | waiting | done | idle, read off the agent's screen
#                 by whichever sidebar is on screen; kept in tmux so a "done"
#                 stays done until that agent's window is looked at
# zsh rather than bash: macOS ships bash 3.2 (no fractional read timeouts).

zmodload zsh/datetime
setopt extended_glob typeset_silent
[[ ${LC_ALL:-${LC_CTYPE:-$LANG}} == *UTF-8* ]] || export LC_CTYPE=en_US.UTF-8

me=$TMUX_PANE
[[ -n $me ]] || { print -u2 "sidebar-ui.zsh: not inside tmux"; exit 1; }
scripts=${0:A:h}
# pane_current_command of an agent; Claude's native binary is named after its version
agent_cmds='(claude(.exe|)|opencode|codex|aider|gemini|cursor-agent|amp|crush|goose|<->.<->.<->)'

# gruvbox, as in gruvbox.conf
typeset -A c
for k v in gray 928374 fg4 a89984 fg2 d5c4a1 fg1 ebdbb2 line 504945 yellow fabd2f \
    green b8bb26 aqua 8ec07c orange fe8019 red fb4934; do
  c[$k]=$'\e'"[38;2;$((16#${v[1,2]}));$((16#${v[3,4]}));$((16#${v[5,6]}))m"
done
# cursor row, current session's row (the pane itself is bg0_h, set by sidebar.sh)
sel=$'\e[48;2;60;56;54m' here=$'\e[48;2;40;40;40m' bold=$'\e[1m' nobold=$'\e[22m' reset=$'\e[0m'
sgr=$'\e'"\[[0-9;]#m"           # pattern matching one color/style sequence
spin=(⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏)
SPIN=⣿                          # placeholder for the spinner frame, swapped in at render

integer W=34 H=40 visible=0 focused=0 top=0 cur=1 follow=1 help=0 anim=0 finding=0
integer n_srv n_work n_wait n_done n_dirty n_shown
float next_load=0 next_scan=0 next_git=0 msg_until=0
my_sid= my_win= cursor= confirm= msg= filter= sb= last_hdr=
typeset -a S_id S_name S_age S_alert S_dirty R_key R_sess R_line R_bg   # R_key '' = spacer row
typeset -A srv agt pane_win srv_port sess_port

# fit <text> <cells>: REPLY = text, cut with … if wider than cells
fit() {
  REPLY=$1
  (( ${(m)#REPLY} <= $2 )) && return
  while (( $#REPLY && ${(m)#REPLY} > $2 - 1 )); do REPLY=${REPLY[1,-2]}; done
  REPLY+=…
}

# line <left> <right>: REPLY = left and right (colors allowed) spread over the row
line() {
  local l=${1//${~sgr}} r=${2//${~sgr}} e
  integer gap=$(( W - 1 - ${(m)#l} - ${(m)#r} ))
  (( gap < 1 )) && gap=1
  REPLY="$1${(l:gap:)e}$2"
}

# ago <seconds>: REPLY = short age, e.g. 5m
ago() {
  if (( $1 < 60 )); then REPLY=now
  elif (( $1 < 3600 )); then REPLY=$(( $1 / 60 ))m
  elif (( $1 < 86400 )); then REPLY=$(( $1 / 3600 ))h
  else REPLY=$(( $1 / 86400 ))d
  fi
}

# classify <screen>: REPLY = working | waiting | idle, REPLY2 = time spent working
classify() {
  local -a l=( ${(f)1} ) m
  (( $#l > 15 )) && l=( ${l[-15,-1]} )
  local t=${(F)l} prompt=${(F)${l[-10,-1]}}
  (( $#l > 10 )) || prompt=$t
  REPLY=idle REPLY2=
  # Claude Code's status line while busy: "✶ Flowing… (28m 23s · ↓ 165.6k tokens)"
  m=( ${(M)l:#[^[:space:]]\ [[:alpha:]][[:alpha:]\ -]#…\ \(*} )
  if (( $#m )) || [[ $t == *(#i)esc(\ to|)\ interrupt* ]]; then
    REPLY=working
    [[ $m[1] == *\((#b)(<->[hms])* ]] && REPLY2=$match[1]
  # permission / question menus sit right at the bottom
  elif [[ $prompt == *('❯ 1. '|'(y/n)'|'[y/N]'|'[Y/n]'|'Allow once')* ]]; then
    REPLY=waiting
  fi
}

load() {
  local line id sid st title g tc r e
  local -a f ids sets screens tq
  local -A a_sid a_seen a_prev a_title a_cmd a_state a_time
  integer seen was=$focused wasvis=$visible k
  S_id=() S_name=() S_age=() S_alert=() S_dirty=() srv=() agt=() pane_win=() srv_port=() sess_port=()
  n_srv=0 n_work=0 n_wait=0 n_done=0 n_dirty=0

  # age = since you were last in it (since creation if never attached)
  for line in ${(f)"$(tmux list-sessions -F $'#{session_id}\t#{session_name}\t#{session_last_attached}\t#{session_created}\t#{@git_dirty}\t#{@sidebar-bg}\t#{session_alerts}' 2>/dev/null)"}; do
    f=( "${(@ps:\t:)line}" )
    ago $(( EPOCHSECONDS - ${f[3]:-$f[4]} ))
    S_id+=( $f[1] ) S_name+=( $f[2] ) S_age+=( $REPLY ) S_dirty+=( "$f[5]" ) S_alert+=( "$f[7]" )
    sb=$f[6]
    [[ -n $f[5] ]] && (( n_dirty++ ))
  done

  for line in ${(f)"$(tmux list-panes -a -F $'#{pane_id}\t#{session_id}\t#{window_id}\t#{window_active}\t#{session_attached}\t#{pane_active}\t#{@sidebar}\t#{pane_current_command}\t#{@pane_port}\t#{@agent_state}\t#{pane_width}\t#{pane_height}\t#{pane_title}' 2>/dev/null)"}; do
    f=( "${(@ps:\t:)line}" )
    id=$f[1] sid=$f[2] pane_win[$f[1]]=$f[3]
    (( seen = f[4] && f[5] ))
    if [[ $id == $me ]]; then
      my_sid=$sid my_win=$f[3] W=$f[11] H=$f[12] visible=$seen
      (( focused = seen && f[6] ))
      continue
    fi
    [[ -n $f[7] ]] && continue                       # another sidebar
    if [[ -n $f[9] ]]; then
      (( n_srv++ ))
      srv_port[$id]=${f[9]%%,*}
      [[ -n $sess_port[$sid] ]] || sess_port[$sid]=$srv_port[$id]
      srv[$sid]+="v:$id"$'\t'"${c[green]} ${c[fg2]}:${f[9]//,/ :}  ${c[gray]}$f[8]"$'\t\n'
    fi
    if [[ $f[8] == ${~agent_cmds} ]]; then
      ids+=( $id )
      a_sid[$id]=$sid a_seen[$id]=$seen a_prev[$id]=$f[10] a_cmd[$id]=$f[8]
      a_title[$id]=${(pj:\t:)f[13,-1]}
    fi
  done

  # Agent states: read every agent's screen in one tmux call
  if (( visible && $#ids )); then
    for id in $ids; do tq+=( capture-pane -p -t $id \; display -p @@sidebar@@ \; ); done
    screens=( "${(@ps:@@sidebar@@\n:)$(tmux $tq[1,-2] 2>/dev/null)}" )
    for (( k = 1; k <= $#ids; k++ )); do
      id=$ids[k]
      classify "$screens[k]"
      st=$REPLY a_time[$id]=$REPLY2
      # finished while nobody was looking: "done" until its window is shown
      [[ $st == idle && $a_prev[$id] == (working|done) ]] && (( ! a_seen[$id] )) && st=done
      if [[ $st != $a_prev[$id] ]]; then
        sets+=( set -p -t $id @agent_state $st \; )
        if [[ -n $a_prev[$id] && $st == (done|waiting) ]] && (( ! a_seen[$id] )); then
          title=${a_title[$id]##[^[:alnum:]]#}
          tmux display-message -d 4000 "${${st:#done}:+◆ needs input}${${st:#waiting}:+✓ finished} · ${S_name[${S_id[(ie)$a_sid[$id]]}]} · ${title:-$a_cmd[$id]}"
        fi
      fi
      a_state[$id]=$st
    done
    (( $#sets )) && tmux $sets[1,-2]
  else
    for id in $ids; do a_state[$id]=$a_prev[$id]; done
  fi

  for id in $ids; do
    title=${a_title[$id]##[^[:alnum:]]#}
    [[ -z $title || $title == ${HOST%%.*}* ]] && title=${${a_cmd[$id]%.exe}/<->.<->.<->/claude}
    case $a_state[$id] in
      working) g="${c[orange]}$SPIN" tc=$c[fg2] r="${c[gray]}$a_time[$id]"; (( n_work++ )) ;;
      waiting) g="${c[yellow]}◆" tc=$c[yellow] r="${c[yellow]}input"; (( n_wait++ )) ;;
      done)    g="${c[aqua]}✓" tc=$c[fg1] r="${c[aqua]}done"; (( n_done++ )) ;;
      *)       g="${c[gray]}○" tc=$c[gray] r= ;;
    esac
    e=${r//${~sgr}}
    fit "$title" $(( W - 9 - ${(m)#e} ))
    agt[$a_sid[$id]]+="a:$id"$'\t'"$g $tc$REPLY"$'\t'"$r"$'\n'
  done

  if (( visible && EPOCHREALTIME >= next_scan )); then
    next_scan=$(( EPOCHREALTIME + 5 ))
    "$scripts/session-port.sh" </dev/null >/dev/null 2>&1 &!
  fi
  if (( visible && EPOCHREALTIME >= next_git )); then
    next_git=$(( EPOCHREALTIME + 10 ))
    "$scripts/session-git.sh" </dev/null >/dev/null 2>&1 &!
  fi
  next_load=$(( EPOCHREALTIME + (visible ? 1 : 30) ))
  (( anim = visible && n_work ))
  (( focused && !was )) && cursor="s:$my_sid" follow=1
  (( !focused )) && confirm= help=0 follow=1 finding=0 filter=
  build
  if (( visible )); then
    (( wasvis )) || last_hdr=
    header
    if [[ $REPLY != "$last_hdr" ]]; then
      last_hdr=$REPLY
      tmux set -g @sidebar-header "$REPLY" \; refresh-client -S
    fi
  fi
}

# The sidebar's tab, shown by status-left (gruvbox.conf) right above the
# sidebar: a flat [icon Sessions | count] tab, aqua while the sidebar is
# focused, then live counts, padded to the sidebar's width and closed by a
# piece of the border so the window tabs start over the main pane. tmux formats
# can't pad to a computed width, hence written from here.
header() {
  local b=${sb:-default} on off stats= s e z
  local -a st
  integer budget used=0 pad
  on="#[fg=$b]#[bg=#8ec07c]#[bold]  Sessions #[nobold]#[fg=#ebdbb2]#[bg=#504945] $#S_id "
  off="#[fg=#ebdbb2]#[bg=#504945]  Sessions #[fg=#a89984]#[bg=#3c3836] $#S_id "
  # needs you, busy, servers, finished, uncommitted: as many as fit, in that order
  (( n_wait ))  && st+=( "#[fg=#fabd2f]◆ $n_wait" )
  (( n_work ))  && st+=( "#[fg=#fe8019]✻ $n_work" )
  (( n_srv ))   && st+=( "#[fg=#b8bb26] $n_srv" )
  (( n_done ))  && st+=( "#[fg=#8ec07c]✓ $n_done" )
  (( n_dirty )) && st+=( "#[fg=#fe8019]± $n_dirty" )
  e=${off//\#\[[^]]#\]}
  budget=$(( W - 2 - ${#e} ))
  for s in $st; do
    e=${s//\#\[[^]]#\]}
    (( used + ${#e} + 1 <= budget )) || break
    stats+=" $s" used+=$(( ${#e} + 1 ))
  done
  (( pad = budget - used, pad = pad < 0 ? 0 : pad ))
  REPLY="#[bg=$b] #{?#{@sidebar},$on,$off}#[bg=$b]${(l:pad:)z}$stats #[bg=default]"
  REPLY+="#{?#{||:#{@sidebar},#{&&:#{>:#{window_panes},2},#{&&:#{pane_at_top},#{==:#{pane_left},$(( W + 1 ))}}}},#[fg=#fabd2f],#[fg=#3c3836]}│"
}

build() {
  local sid bar idx nc bg right e q=${(L)filter}
  local -a subs f
  integer i j
  R_key=() R_sess=() R_line=() R_bg=()
  n_shown=0
  for (( i = 1; i <= $#S_id; i++ )); do
    sid=$S_id[i]
    [[ -n $q && ${(L)S_name[i]} != *"$q"* ]] && continue
    (( n_shown++ )) && R_key+=( '' ) R_sess+=( '' ) R_line+=( '' ) R_bg+=( '' )
    subs=( ${(f)srv[$sid]} ${(f)agt[$sid]} )
    # current session yellow; others bright when something runs in them, dim
    # when idle; orange (either way) with uncommitted changes
    if [[ $sid == $my_sid ]]; then bar="${c[yellow]}▍" nc=$c[yellow]$bold bg=$here right=
    else bar=' ' bg= right="${c[gray]}$S_age[i]"; (( $#subs )) && nc=$c[fg1] || nc=$c[fg4]; fi
    [[ -n $S_dirty[i] ]] && nc+=$c[orange]
    [[ -n $S_alert[i] ]] && right="${c[red]}${right:+ $right}"   # a window rang the bell
    (( i <= 9 )) && idx="${c[gray]}$i" || idx=' '
    e=${right//${~sgr}}
    fit "$S_name[i]" $(( W - 7 - ${(m)#e} ))
    line "$bar $idx  $nc$REPLY$nobold" "$right"
    R_key+=( "s:$sid" ) R_sess+=( $sid ) R_line+=( "$REPLY" ) R_bg+=( "$bg" )
    for (( j = 1; j <= $#subs; j++ )); do
      f=( "${(@ps:\t:)subs[j]}" )
      line "$bar    $f[2]" "$f[3]"
      R_key+=( $f[1] ) R_sess+=( $sid ) R_line+=( "$REPLY" ) R_bg+=( '' )
    done
  done
  cur=${R_key[(Ie)$cursor]}
  if (( !cur )) || [[ -z $cursor ]]; then
    cur=${R_key[(Ie)s:$my_sid]}
    (( cur )) || cur=1
    cursor=$R_key[cur]
  fi
}

render() {
  # row 1 blank, rows 2..H-2 list, then a rule and one footer line; the title
  # sits above, in the status line (@sidebar-header)
  integer t y i row n=$#R_key bh=$(( H - 3 )) anchor
  (( t = EPOCHREALTIME * 10 ))
  local frame=$spin[$(( t % 10 + 1 ))] out=$'\e[1;1H\e[K' s e f bg K=$c[yellow] G=$c[gray]

  if (( help )); then
    local -a h=(
      "j k ↑ ↓" "next/prev session" "J K tab" "line by line"
      "1-9" "go to session"        "⏎ l → click" "open"
      "/" "find session"           "a" "new agent window"
      "x" "stop dev server"        "w" "server in browser"
      "r" "rename session"         "n" "new session"
      "d" "kill session"           "R" "refresh now"
      "esc q" "back to pane"       "prefix b" "hide sidebar"
    )
    for (( y = 0; y < bh; y++ )); do
      row=$(( y + 2 )) i=$(( y * 2 + 1 ))
      if (( i < $#h )); then out+=$'\e['$row$';1H'"  $K${(mr:13:)h[i]}$G$h[i+1]"$'\e[K'
      else out+=$'\e['$row$';1H\e[K'; fi
    done
  else
    (( anchor = focused ? cur : ${R_key[(Ie)s:$my_sid]} ))
    if (( follow && anchor )); then
      (( anchor <= top )) && top=$(( anchor - 1 ))
      (( anchor > top + bh )) && top=$(( anchor - bh ))
    fi
    (( top > n - bh )) && top=$(( n - bh ))
    (( top < 0 )) && top=0
    for (( y = 0; y < bh; y++ )); do
      row=$(( y + 2 )) i=$(( top + y + 1 ))
      if (( i <= n )); then
        s=${R_line[i]//$SPIN/$frame} bg=$R_bg[i]
        (( focused && i == cur )) && bg=$sel
        out+=$'\e['$row$';1H'"$bg$s"$'\e[K'"$reset"
      else
        out+=$'\e['$row$';1H\e[K'
      fi
    done
  fi

  if (( finding )); then
    line " $K/ ${c[fg1]}$filter$K▏" "$G$n_shown/$#S_id"
    f=$REPLY
  elif [[ -n $confirm ]]; then
    fit "kill ${S_name[${S_id[(ie)$confirm]}]}?" $(( W - 9 ))
    f=" ${c[red]}${bold}$REPLY${nobold}  ${K}y$G/${K}n"
  elif (( msg_until > EPOCHREALTIME )); then
    fit "$msg" $(( W - 2 ))
    f=" ${c[fg2]}$REPLY"
  elif (( focused )); then
    case $R_key[cur] in
      v:*) f=" $K⏎$G go  ${K}w$G browser  ${K}x$G stop  $K?$G keys" ;;
      a:*) f=" $K⏎$G go  ${K}/$G find  ${K}a$G agent  $K?$G keys" ;;
      *)   f=" $K⏎$G open  ${K}/$G find  ${K}a$G agent  $K?$G keys" ;;
    esac
  else
    f=
    (( n_srv )) && f+=" ${c[green]} ${c[fg2]}$n_srv "
    (( n_work )) && f+=" ${c[orange]}$frame ${c[fg2]}$n_work "
    (( n_wait )) && f+=" ${c[yellow]}◆ ${c[fg2]}$n_wait "
    (( n_done )) && f+=" ${c[aqua]}✓ ${c[fg2]}$n_done "
    [[ -z $f ]] && f=" ${G}no servers or agents running"
  fi
  out+=$'\e['$(( H - 1 ))$';1H'"${c[line]}${(l:W::─:)e}"$'\e[K'
  out+=$'\e['$H$';1H'"$f"$'\e[K'"$reset"
  print -rn -- "$out"
}

flash() { msg=$1 msg_until=$(( EPOCHREALTIME + 2.5 )) }

# back to the pane the sidebar was entered from
back() { tmux select-pane -t $me -l 2>/dev/null || tmux select-pane -t $me -R }

open() {
  local key=$R_key[cur] sid=$R_sess[cur] target=${R_key[cur]#?:}
  [[ -n $key ]] || return
  if [[ $key == s:* ]]; then
    [[ $sid == $my_sid ]] && { back; return }
    # leave this window on its main pane, and don't land on the other sidebar
    tmux select-pane -t $me -l 2>/dev/null
    tmux switch-client -t $sid
    tmux if -F -t $sid '#{@sidebar}' "last-pane -t '$sid'"
  else
    [[ $pane_win[$target] != $my_win ]] && tmux select-pane -t $me -l 2>/dev/null
    tmux switch-client -t $sid \; select-window -t $target \; select-pane -t $target
  fi
  next_load=0
}

new_agent() {
  local sid=$R_sess[cur] cmd=$(tmux show -gqv @sidebar-agent-command)
  [[ $sid == $my_sid ]] && tmux select-pane -t $me -l 2>/dev/null
  tmux new-window -t "$sid:" -c '#{pane_current_path}' "${cmd:-claude}" \; switch-client -t $sid
  next_load=0
}

# open the selected server (or the session's first one) in the browser
browse() {
  local port
  [[ $R_key[cur] == v:* ]] && port=$srv_port[${R_key[cur]#v:}] || port=$sess_port[$R_sess[cur]]
  [[ -n $port ]] || { flash "no dev server in this session"; return }
  command open "http://localhost:$port" >/dev/null 2>&1 &!
  flash "opening localhost:$port"
}

stop_server() {
  local sid=$R_sess[cur]
  flash "stopping servers in ${S_name[${S_id[(ie)$sid]}]}…"
  "$scripts/session-kill-server.sh" $sid </dev/null >/dev/null 2>&1 &!
  next_load=$(( EPOCHREALTIME + 1.5 ))
}

kill_session() {
  local sid=$confirm
  confirm=
  # killing the session on screen would detach the client: move it first
  [[ $sid == $my_sid ]] && { tmux switch-client -l 2>/dev/null || tmux switch-client -n }
  tmux kill-session -t $sid
  next_load=0
}

# move <±1>: to the next row that isn't a spacer
move() {
  integer i=$(( cur + $1 ))
  while (( i >= 1 && i <= $#R_key )) && [[ -z $R_key[i] ]]; do (( i += $1 )); done
  (( i >= 1 && i <= $#R_key )) && jump $i
}

jump() { cur=$1 cursor=$R_key[$1] follow=1 }

# after the filter changed: select the first match, or back to this session
refilter() {
  cursor=
  [[ -z $filter ]] && cursor=s:$my_sid
  build
  [[ -n $filter ]] && (( $#R_key )) && jump 1
}

move_session() {
  integer i=$(( cur + $1 ))
  while (( i >= 1 && i <= $#R_key )) && [[ $R_key[i] != s:* ]]; do (( i += $1 )); done
  (( i >= 1 && i <= $#R_key )) && jump $i
}

mouse() {  # mouse <SGR params, e.g. "<0;12;5M">
  local -a p=( ${(s:;:)${1#<}} )
  integer btn=$p[1] y=${p[3]%[Mm]} i
  [[ $p[3] == *M ]] || return
  case $btn in
    0)
      (( help )) && { help=0; return }
      i=$(( top + y - 1 ))
      (( y >= 2 && y <= H - 2 && i >= 1 && i <= $#R_key )) && [[ -n $R_key[i] ]] || return
      jump $i
      open
      ;;
    64) (( top = top > 2 ? top - 2 : 0 )); follow=0 ;;
    65) (( top += 2 )); follow=0 ;;
  esac
}

key() {
  local k=$1 ch seq=
  if [[ $k == $'\e' ]]; then
    if ! read -rsk 1 -t 0.02 ch; then k=esc
    elif [[ $ch == '[' ]]; then
      while read -rsk 1 -t 0.02 ch; do seq+=$ch; [[ $ch == [@-~] ]] && break; done
      k=csi:$seq
    else k=alt:$ch; fi
  fi
  if [[ -n $confirm ]]; then
    [[ $k == y ]] && kill_session || confirm=
    return
  fi
  if (( finding )); then
    case $k in
      esc|$'\x03') finding=0 filter=; refilter ;;
      $'\r'|$'\n') open; finding=0 filter=; refilter ;;
      $'\x7f'|$'\b') filter=${filter[1,-2]}; refilter ;;
      csi:A|$'\x10') move_session -1 ;;
      csi:B|$'\x0e') move_session 1 ;;
      $'\t') move 1 ;;
      csi:Z) move -1 ;;
      csi:\<*) mouse ${seq} ;;
      csi:I|csi:O|csi:24~) next_load=0 ;;
      csi:*|alt:*) ;;
      *) [[ $k == [[:print:]] ]] && { filter+=$k; refilter } ;;
    esac
    return
  fi
  case $k in
    j|$'\x0e'|csi:B|csi:6~) move_session 1 ;;
    k|$'\x10'|csi:A|csi:5~) move_session -1 ;;
    J|$'\t') move 1 ;;                                 # line by line, into servers/agents
    K|csi:Z) move -1 ;;
    g|csi:H|csi:1~) jump 1 ;;
    G|csi:F|csi:4~) jump $#R_key ;;
    [1-9]) (( k <= $#S_id )) && { cursor=s:$S_id[k]; cur=${R_key[(Ie)$cursor]}; open } ;;
    $'\r'|$'\n'|l|o|csi:C) open ;;
    /) finding=1 filter= ;;
    a) new_agent ;;
    w) browse ;;
    x) stop_server ;;
    d) confirm=$R_sess[cur] ;;
    r) tmux command-prompt -I "${S_name[${S_id[(ie)$R_sess[cur]]}]}" -p "rename session:" "rename-session -t '$R_sess[cur]' -- '%%'" ;;
    n) tmux command-prompt -p "new session:" "new-session -d -s '%%' ; switch-client -t '=%%'" ;;
    R) next_load=0 next_scan=0 ;;
    '?') (( help = !help )) ;;
    esc|q|$'\x03') (( help )) && help=0 || back ;;
    csi:I|csi:O|csi:24~) next_load=0 ;;              # focus change, or a poke from sidebar.sh
    csi:\<*) mouse ${seq} ;;
  esac
}

print -n $'\e[?1049h\e[?25l\e[?7l\e[?1000h\e[?1006h\e[?1004h'
stty -echo -icanon -isig -ixon 2>/dev/null
TRAPEXIT() { print -n $'\e[?1004l\e[?1006l\e[?1000l\e[?7h\e[?25h\e[?1049l' }
# a resize doesn't interrupt read either: poke ourselves to reload the size
TRAPWINCH() { tmux send-keys -t $me F12 2>/dev/null }

float timeout
while true; do
  (( EPOCHREALTIME >= next_load )) && load
  (( visible )) && render
  if (( !visible )); then timeout=30
  elif (( anim )); then timeout=0.1
  else (( timeout = next_load - EPOCHREALTIME, timeout = timeout < 0.05 ? 0.05 : timeout ))
  fi
  read -rsk 1 -t $timeout k && key "$k"
done
