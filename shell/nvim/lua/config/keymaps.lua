-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- ~/.config/nvim/lua/config/keymaps.lua
-- Remap the Snacks notification history
vim.keymap.del("n", "<leader>n") -- Delete the default mapping

vim.keymap.set("n", "<leader>nh", function()
  require("snacks.picker").notifications()
end, { desc = "Snacks Notifications" })

-- Define a consistent scroll amount for a half page
vim.keymap.set("n", "<C-d>", function()
  local scroll_amount = math.max(1, math.floor(vim.fn.winheight(0) * 0.5))
  return tostring(scroll_amount) .. "j" -- Use 'j' to scroll down without side effects
end, { expr = true, desc = "Scroll Down (Half Page)" })

vim.keymap.set("n", "<C-u>", function()
  local scroll_amount = math.max(1, math.floor(vim.fn.winheight(0) * 0.5))
  return tostring(scroll_amount) .. "k" -- Use 'k' to scroll up without side effects
end, { expr = true, desc = "Scroll Up (Half Page)" })

-- Define a consistent scroll amount for a quarter page
vim.keymap.set("n", "<S-C-d>", function()
  local scroll_amount = math.max(1, math.floor(vim.fn.winheight(0) * 0.25))
  return tostring(scroll_amount) .. "j" -- Use 'j' to scroll down without side effects
end, { expr = true, desc = "Scroll Down (Quarter Page)" })

vim.keymap.set("n", "<S-C-u>", function()
  local scroll_amount = math.max(1, math.floor(vim.fn.winheight(0) * 0.25))
  return tostring(scroll_amount) .. "k" -- Use 'k' to scroll up without side effects
end, { expr = true, desc = "Scroll Up (Quarter Page)" })
