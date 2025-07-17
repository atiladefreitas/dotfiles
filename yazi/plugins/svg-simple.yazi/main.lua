local M = {}

function M:peek(job)
	local cache = ya.file_cache(job)
	if not cache then
		return
	end

	if not self:preload(job) then
		return
	end

	ya.image_show(cache, job.area)
	ya.preview_widgets(job, {})
end

function M:seek() end

function M:preload(job)
	local cache = ya.file_cache(job)
	if not cache or fs.cha(cache) then
		return true
	end

	-- Use preview area dimensions
	local max_width = job.area.w * 8  -- Approximate character width in pixels
	local max_height = job.area.h * 16 -- Approximate character height in pixels
	
	-- Ensure minimum reasonable size
	max_width = math.max(max_width, 400)
	max_height = math.max(max_height, 400)
	
	-- Use only width constraint to preserve aspect ratio
	local child, code = Command("rsvg-convert")
		:arg("--format")
		:arg("png")
		:arg("--width")
		:arg(tostring(math.min(max_width, 800)))
		:arg(tostring(job.file.url))
		:stdout(Command.PIPED)
		:spawn()

	if not child then
		ya.err("Failed to spawn rsvg-convert: " .. tostring(code))
		return false
	end

	local output, err = child:wait_with_output()
	if not output then
		ya.err("rsvg-convert failed: " .. tostring(err))
		return false
	end

	if not output.status.success then
		ya.err("rsvg-convert exited with error")
		return false
	end

	local ok, werr = fs.write(cache, output.stdout)
	return ok, werr
end

return M 