local Toggle = {}

local toggleTable = {
	["true"] = "false",
	["True"] = "False",
	["TRUE"] = "FALSE",
}

for k, v in pairs(toggleTable) do
	toggleTable[v] = k
end

local function errorHandler(err)
	if not err == nil then
		vim.notify("Error toggling: " .. err, vim.log.levels.ERROR)
	end
end

function Toggle.toggleBool(str)
	if str ~= nil then
		vim.notify("no bro it does `iw` anyway don't do it yourself", vim.log.levels.WARN)
	end

	vim.cmd("normal! yiw")
	local yankedWord = vim.fn.getreg('"')
	local replacement = toggleTable[yankedWord]

	if word == nil then
		vim.notify("you can't do this to that", vim.log.levels.INFO)
	end

	xpcall(function()
		vim.cmd("normal! ciw" .. word)
	end, errorHandler)
end

return Toggle
