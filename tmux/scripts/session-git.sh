#!/usr/bin/env bash
# Usage: session-git.sh
# Sets the @git_dirty session option to 1 for every session whose directory
# (session_path) is a git repo with uncommitted changes, untracked files
# included, and unsets it everywhere else. The sidebar shows those sessions
# in orange. --no-optional-locks: never take index.lock from under a commit.
args=()
while IFS=$'\t' read -r session path; do
  if [ -n "$(git --no-optional-locks -C "$path" status --porcelain 2>/dev/null | head -1)" ]; then
    args+=(set -t "=$session:" @git_dirty 1 \;)
  else
    args+=(set -u -t "=$session:" @git_dirty \;)
  fi
done < <(tmux list-sessions -F $'#{session_name}\t#{session_path}' 2>/dev/null)

[ ${#args[@]} -gt 0 ] && tmux "${args[@]}"
