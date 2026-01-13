-- zlint integration for LazyVim
-- https://github.com/DonIsaac/zlint
-- Custom implementation that runs zlint from project root

local M = {}

local namespace = vim.api.nvim_create_namespace("zlint")

function M.run_zlint()
  local bufnr = vim.api.nvim_get_current_buf()
  local filepath = vim.fn.expand("%:p")
  local dir = vim.fn.expand("%:p:h")

  -- Find project root
  local root_file = vim.fs.find({ "build.zig", "build.zig.zon" }, {
    path = dir,
    upward = true,
  })[1]

  if not root_file then
    return
  end

  local root = vim.fn.fnamemodify(root_file, ":h")
  local relpath = filepath:sub(#root + 2)

  -- Run zlint
  local cmd = { "zlint", "-f", "json", relpath }

  vim.fn.jobstart(cmd, {
    cwd = root,
    stdout_buffered = true,
    on_stdout = function(_, data)
      if not data then return end

      local diagnostics = {}

      for _, line in ipairs(data) do
        if line and line ~= "" then
          local ok, decoded = pcall(vim.json.decode, line)
          if ok and decoded then
            local severity_map = {
              error = vim.diagnostic.severity.ERROR,
              warn = vim.diagnostic.severity.WARN,
              warning = vim.diagnostic.severity.WARN,
              info = vim.diagnostic.severity.INFO,
              hint = vim.diagnostic.severity.HINT,
            }

            local severity = severity_map[decoded.level] or vim.diagnostic.severity.WARN

            local lnum, col, end_lnum, end_col = 0, 0, 0, 0
            if decoded.labels and #decoded.labels > 0 then
              local label = decoded.labels[1]
              for _, l in ipairs(decoded.labels) do
                if l.primary == true then
                  label = l
                  break
                end
              end

              if label.start then
                lnum = (label.start.line or 1) - 1
                col = (label.start.column or 1) - 1
              end
              if label["end"] then
                end_lnum = (label["end"].line or (lnum + 1)) - 1
                end_col = (label["end"].column or col) - 1
              end
            end

            local message = decoded.message or "Unknown error"
            if decoded.code and decoded.code ~= vim.NIL then
              message = "[" .. decoded.code .. "] " .. message
            end
            if decoded.help and decoded.help ~= vim.NIL and type(decoded.help) == "string" then
              message = message .. " | " .. decoded.help
            end

            table.insert(diagnostics, {
              lnum = lnum,
              col = col,
              end_lnum = end_lnum,
              end_col = end_col,
              severity = severity,
              message = message,
              source = "zlint",
            })
          end
        end
      end

      -- Set diagnostics
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(bufnr) then
          vim.diagnostic.set(namespace, bufnr, diagnostics)
        end
      end)
    end,
  })
end

return {
  {
    "mfussenegger/nvim-lint",
    optional = true,
  },
  {
    -- Dummy plugin entry to set up zlint
    dir = vim.fn.stdpath("config"),
    name = "zlint-custom",
    event = { "BufReadPost", "BufWritePost" },
    config = function()
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
        group = vim.api.nvim_create_augroup("zlint-custom", { clear = true }),
        pattern = { "*.zig", "*.zon" },
        callback = function()
          M.run_zlint()
        end,
      })

      -- Run immediately for current buffer if it's a zig file
      if vim.bo.filetype == "zig" or vim.bo.filetype == "zon" then
        vim.defer_fn(function()
          M.run_zlint()
        end, 100)
      end
    end,
  },
}
