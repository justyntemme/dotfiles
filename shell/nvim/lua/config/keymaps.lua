-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- ~/.config/nvim/lua/config/keymaps.lua
-- ~/.config/nvim/lua/config/keymaps.lua

local map = vim.keymap.set

-- State to remember which pane we are targeting
_G.kitty_zig_target_id = nil

local function get_local_kitty_targets()
  -- Get JSON state of all kitty windows
  local result = vim.system({ "kitty", "@", "ls" }, { text = true }):wait()
  if result.code ~= 0 then
    return {}
  end

  local os_windows = vim.json.decode(result.stdout)
  local candidates = {}

  -- Target ONLY the active tab in the active OS window
  for _, os_window in ipairs(os_windows) do
    if os_window.is_focused then
      for _, tab in ipairs(os_window.tabs) do
        if tab.is_focused then
          for _, win in ipairs(tab.windows) do
            -- Filter out the window Neovim is running in
            if not win.is_focused then
              table.insert(candidates, {
                id = win.id,
                title = win.title,
                cmdline = table.concat(win.cmdline, " "),
              })
            end
          end
        end
      end
    end
  end
  return candidates
end

local function run_zig_in_kitty()
  -- 1. Save current file
  vim.cmd("write")
  local file = vim.fn.expand("%:p")

  -- 2. Command: Ctrl+C (to kill previous run) + zig run + Enter
  local zig_cmd = "\x03" .. "zig run " .. file .. "\r"

  -- 3. If we already have a target, send it immediately
  if _G.kitty_zig_target_id then
    vim.system({
      "kitty",
      "@",
      "send-text",
      "--match",
      "id:" .. _G.kitty_zig_target_id,
      zig_cmd,
    }, { detach = true })
    return
  end

  -- 4. No target? Find candidates in the current tab
  local candidates = get_local_kitty_targets()

  if #candidates == 0 then
    vim.notify("No other splits found in this tab!", vim.log.levels.WARN)
    return
  end

  -- Helper to lock the choice and execute
  local function bind_and_run(id)
    _G.kitty_zig_target_id = id
    -- Briefly focus the window so the user sees which one was selected
    vim.system({ "kitty", "@", "focus-window", "--match", "id:" .. id })

    -- Small delay to allow the focus flash, then send command and return focus to nvim
    vim.defer_fn(function()
      vim.system({ "kitty", "@", "send-text", "--match", "id:" .. id, zig_cmd })
      vim.system({ "kitty", "@", "focus-window", "--match", "id:" .. vim.env.KITTY_WINDOW_ID })
    end, 100)
  end

  -- Auto-run if only one split exists
  if #candidates == 1 then
    bind_and_run(candidates[1].id)
  else
    -- Open selection menu if multiple splits exist
    vim.ui.select(candidates, {
      prompt = "Select Output Pane:",
      format_item = function(item)
        return string.format("ID: %s | %s", item.id, item.cmdline)
      end,
    }, function(choice)
      if choice then
        bind_and_run(choice.id)
      end
    end)
  end
end

-- KEYMAPS
-- <leader>zr to run
map("n", "<leader>zr", run_zig_in_kitty, { desc = "Zig Run (Kitty Split)" })

-- <leader>zR to "un-lock" the pane (if you close it or want a different one)
map("n", "<leader>zR", function()
  _G.kitty_zig_target_id = nil
  vim.notify("Kitty target detached", vim.log.levels.INFO)
end, { desc = "Reset Zig Target Pane" })

-- Remap the Snacks notification history
vim.keymap.del("n", "<leader>n") -- Delete the default mapping

vim.keymap.set("n", "<leader>nh", function()
  require("snacks.picker").notifications()
end, { desc = "Snacks Notifications" })

vim.keymap.set("n", "<leader>nn", "<cmd>Noice<cr>", { desc = "Noice" })

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
