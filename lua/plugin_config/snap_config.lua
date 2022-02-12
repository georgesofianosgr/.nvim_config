local snap = require("snap")
local module = {}

module.setup = function()
	snap.register.map({ "n" }, { "<C-p>" }, function()
		snap.run({
			prompt = "Files",
			producer = snap.get("consumer.fzy")(snap.get("producer.ripgrep.file")),
			select = snap.get("select.file").select,
			multiselect = snap.get("select.file").multiselect,
			views = { snap.get("preview.file") },
		})
	end)
	snap.register.map({ "n" }, { "<C-f>" }, function()
		snap.run({
			prompt = "Grep",
			producer = snap.get("producer.ripgrep.vimgrep"),
			select = snap.get("select.vimgrep").select,
			multiselect = snap.get("select.vimgrep").multiselect,
			views = { snap.get("preview.vimgrep") },
		})
	end)
end

return module
