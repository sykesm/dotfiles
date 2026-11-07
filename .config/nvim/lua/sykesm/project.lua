-- project.lua - per-project settings from <root>/.nvim/project.lua
--
-- The file is data: it runs with an empty environment and returns a table.
-- vim.secure.read() prompts once and remembers the answer (see :trust).
--
--   return {
--     lsp = {
--       jdtls = { settings = { java = { format = { enabled = true } } } },
--       gopls = { settings = { gopls = { buildFlags = { '-tags=integration' } } } },
--     },
--   }

local M = {}

local cache = {}
local applied = {}

---@param root? string
---@return table
function M.load(root)
  if not root then
    return {}
  end
  if cache[root] then
    return cache[root]
  end

  local result = {}
  local path = root .. '/.nvim/project.lua'
  if vim.uv.fs_stat(path) then ---@diagnostic disable-line: undefined-field
    local src = vim.secure.read(path)
    if type(src) == 'string' then
      local chunk, err = load(src, '@' .. path, 't', {})
      local ok, value = pcall(chunk or error, err)
      if ok and type(value) == 'table' then
        result = value
      else
        vim.notify(path .. ': ' .. tostring(value), vim.log.levels.ERROR)
      end
    end
  end

  cache[root] = result
  return result
end

---@param root? string
---@param name string
---@return table
function M.lsp(root, name)
  return (M.load(root).lsp or {})[name] or {}
end

--- Push project settings to a running client. Assigning config.settings in
--- before_init doesn't reach client.settings, so this runs after attach.
---@param client vim.lsp.Client
function M.apply(client)
  if applied[client.id] then
    return
  end
  applied[client.id] = true

  local settings = M.lsp(client.root_dir, client.name).settings
  if settings then
    client.settings = vim.tbl_deep_extend('force', client.settings or {}, settings)
    client:notify('workspace/didChangeConfiguration', { settings = client.settings })
  end
end

return M
