-- nvim-tree.lua

local nvimtree_ok, nvimtree = pcall(require, "nvim-tree")
if not nvimtree_ok then
  return
end

-- recommended settings from nvim-tree documentation
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- configure nvim-tree
nvimtree.setup({
  diagnostics = {
    enable = true,
  },
  actions = {
    open_file = {
      window_picker = {
        enable = true,
      },
    },
  },
  renderer = {
    icons = {
      glyphs = {
        folder = {
          arrow_closed = "⏵",
          arrow_open = "⏷",
        },
      },
    },
  },
})

vim.keymap.set('', '<leader>n', ':NvimTreeToggle<cr>', { noremap = true })
vim.keymap.set('', '<F9>', ':NvimTreeFindFile<cr>', { noremap = true })

vim.cmd[[highlight NvimTreeNormal guibg=NONE ctermbg=NONE]]
