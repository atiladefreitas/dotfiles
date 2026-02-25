local get_hovered = ya.sync(function()
  local h = cx.active.current.hovered
  if not h then
    return nil, nil
  end
  return tostring(h.url), h.mime
end)

return {
  entry = function()
    local url, mime = get_hovered()
    if not url then
      return
    end

    if not mime or not mime:find("^image/") then
      ya.notify {
        title = "Fullscreen Preview",
        content = "Not an image file (mime: " .. tostring(mime) .. ")",
        timeout = 3,
        level = "warn",
      }
      return
    end

    local permit = ui.hide()

    local child, err = Command("bash")
      :arg("-c")
      :arg(
        'clear && chafa --fill=block --symbols=block --size="$(tput cols)x$(tput lines)" '
          .. ya.quote(url)
          .. ' && read -rsn1'
      )
      :stdin(Command.INHERIT)
      :stdout(Command.INHERIT)
      :stderr(Command.INHERIT)
      :spawn()

    if child then
      child:wait()
    end

    permit:drop()
  end,
}
