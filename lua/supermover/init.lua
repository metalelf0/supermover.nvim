local M = {}

local map_helpers = require("supermover.helpers.map")

M.setup = function(opts)
	M.set_keymaps(opts)
end

M.set_keymaps = function(opts)
	local keys_to_bind = map_helpers.dig(opts, "bindings", "move_file") or "<leader>fm"
	local picker = map_helpers.dig(opts, "picker") or "telescope"
	if picker == "telescope" then
		vim.keymap.set("n", keys_to_bind, M.supermove_with_telescope, { desc = "Move current file" })
	elseif picker == "snacks" then
		vim.keymap.set("n", keys_to_bind, M.supermove_with_snacks, { desc = "Move current file" })
	end
end

local function supermover(prompt_bufnr, map)
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	actions.select_default:replace(function()
		actions.close(prompt_bufnr)
		local selection = action_state.get_selected_entry()
		vim.api.nvim_command("Move " .. selection[1])
	end)

	map({ "i", "n" }, "<C-n>", function(prompt_bufnr)
		actions.close(prompt_bufnr)
		local selection = action_state.get_selected_entry()
		local new_dir_name = vim.fn.input("New dir name (under " .. selection[1] .. "): ")

		new_dir = vim.fs.joinpath(selection[1], new_dir_name)
		vim.api.nvim_command("Mkdir " .. new_dir)
		vim.api.nvim_command("Move " .. new_dir)
	end)

	return true
end

M.supermove_with_telescope = function()
	require("telescope.builtin").find_files({
		find_command = { "fd", "--type", "d" },
		attach_mappings = supermover,
		prompt_title = "Choose target dir",
	})
end

M.supermove_with_snacks = function()
	local snacks = require("snacks")
	snacks.picker.pick({
		title = "Directories",
		format = "text",
		finder = function(opts, ctx)
			local proc_opts = {
				cmd = "fd",
				args = { ".", "--type", "directory" },
			}
			return require("snacks.picker.source.proc").proc({ opts, proc_opts }, ctx)
		end,
		confirm = function(picker, item)
			picker:close()
			if item then
				vim.api.nvim_command("Move " .. item.text)
			end
		end,
	})
end

return M
