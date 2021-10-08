local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
  error("This plugins requires nvim-telescope/telescope.nvim")
end

local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local buffer_lines = function(opts)
    opts = opts or {}

    local buffers = vim.tbl_filter(function(buffer)
        return vim.api.nvim_buf_get_option(buffer, "buflisted")
    end, vim.api.nvim_list_bufs())
    local data = {}
    for _, buf in ipairs(buffers) do
        -- required to make sure buffer is loaded even if not displayed in window
        vim.fn.eval("bufload(" .. buf .. ")")
        local buf_lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
        for idx, line in ipairs(buf_lines) do
            if line ~= "" then
                -- could be spun into a entry maker function
                local entry = { value = line, ordinal = line, display = line, bufnr = buf, lnum = idx }
                table.insert(data, entry)
            end
        end
    end
    opts.entry_maker = vim.F.if_nil(opts.entry_maker, function(entry)
        return entry
    end)

    pickers.new(opts, {
        prompt_title = "Buffer Lines",
        finder = finders.new_table { results = data, entry_maker = opts.entry_maker },
        previewer = false,
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                -- Strip leading whitespace
                -- local svalue = selection.value:gsub("^%s*(.-)%s*$", "%1")
                local svalue = selection.value
                vim.api.nvim_put({ svalue }, "l", true, true)
            end)
            return true
        end
    }):find()
end

-- to execute the function
-- buffer_lines()
return telescope.register_extension({ exports = { buffer_lines = buffer_lines } })
