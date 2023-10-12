local M = {}

M.ui_select = function(items, options, on_choice)
    return coroutine.wrap(function()

      local utils = require "fzf-commands-windows.utils"
      local term = require "fzf-commands-windows.term"

      local function feed_keys_termcodes(key)
        vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes(key, true, false, true), "n", true)
      end

      local win_h = vim.api.nvim_win_get_height(0)
      local row, col = unpack(vim.api.nvim_win_get_cursor(0))

      local float_height = 0
      local supplementary_fzf_options
      local _row = 0
      if row < math.ceil(win_h/2) then
        supplementary_fzf_options = (term.fzf_colors .. ' --padding=0,1,1,1 --ansi --reverse --prompt="Choice> "')
        _row = 1
        float_height = win_h - row
      else
        supplementary_fzf_options = (term.fzf_colors .. ' --padding=1,1,0,1 --ansi --prompt="Choice> "')
        _row = _row - #items - 2
        float_height = row
      end

      options = utils.normalize_opts({
        fzf = function(contents, opts)
          return require("fzf").fzf(contents, opts, {
              border = false,
              relative = 'cursor',
              row = _row,
              col = 0,
              width = 60,
              height = math.min(#items + 2, float_height),
              noautocmd = true
            })
        end
      })

      local i = {}
      for k, v in ipairs(items) do
        table.insert(i, term.red .. string.format('%4d', k) .. term.reset .. string.rep(utils.delim,3) .. v)
      end


      local mode = vim.api.nvim_get_mode()
      if not mode.mode:match("^n") then
        feed_keys_termcodes('<C-o>i')
      end

      local line = options.fzf(i, supplementary_fzf_options)
      if not line then
        return
      end

      local indx, choice = unpack(vim.fn.split(line[1], utils.delim..'\\+'))

      coroutine.yield(on_choice(choice, tonumber(indx)))
    end)()
end

return M
