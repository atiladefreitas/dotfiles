local M = {}

function M:setup()
  -- Cache for image dimensions, shared via closure
  local dims = {}

  -- Async function to fetch dimensions for a given url
  local fetch_dims = ya.sync(function(_, url)
    if dims[url] then
      return nil
    end
    return url
  end)

  local save_dims = ya.sync(function(_, url, w, h)
    dims[url] = { w = w, h = h }
    ui.render()
  end)

  -- Subscribe to hover events to trigger dimension fetching
  ps.sub("hover", function()
    local h = cx.active.current.hovered
    if not h then
      return
    end

    local mime = h:mime()
    if not mime or not mime:find("^image/") then
      return
    end

    local url = tostring(h.url)
    if dims[url] then
      ui.render()
      return
    end

    ya.async(function()
      local output = Command("identify")
        :arg("-format")
        :arg("%wx%h")
        :arg("--")
        :arg(url)
        :stdout(Command.PIPED)
        :stderr(Command.NULL)
        :output()

      if output and output.status and output.status.success and output.stdout then
        local w, h = output.stdout:match("^(%d+)x(%d+)")
        if w and h then
          save_dims(url, tonumber(w), tonumber(h))
        end
      end
    end)
  end)

  -- Add image dimensions to the status bar
  Status:children_add(function(self)
    local h = self._current.hovered
    if not h then
      return ""
    end

    local mime = h:mime()
    if not mime or not mime:find("^image/") then
      return ""
    end

    local url = tostring(h.url)
    local d = dims[url]
    if not d then
      return ""
    end

    return ui.Line {
      ui.Span(string.format(" %dx%d ", d.w, d.h)):fg("blue"),
    }
  end, 500, Status.RIGHT)
end

return M
