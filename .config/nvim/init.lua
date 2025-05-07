-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.g.mapleader = " "

vim.keymap.set("n", "<leader>r", function()
  local term_buf = nil
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buftype == "terminal" then
      term_buf = buf
      break
    end
  end

  if not term_buf then
    vim.cmd("botright split | resize 10 | terminal")
    term_buf = vim.api.nvim_get_current_buf()
  else
    local wins = vim.fn.win_findbuf(term_buf)
    if #wins == 0 then
      vim.cmd("botright split")
      vim.api.nvim_set_current_buf(term_buf)
      vim.cmd("resize 10")
    else
      vim.api.nvim_set_current_win(wins[1])
    end
  end

  local file = vim.fn.expand("%:p")
  vim.cmd("!" .. "python3 " .. file)
end, { desc = "Run Python script in split terminal" })

