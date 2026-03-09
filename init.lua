-- ============================================================
--  init.lua — Neovim config for DevOps / Red Team workflow
--  Install lazy.nvim first:
--  git clone https://github.com/folke/lazy.nvim ~/.local/share/nvim/lazy/lazy.nvim
-- ============================================================

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ── Core options ─────────────────────────────────────────────
local opt = vim.opt
opt.number         = true
opt.relativenumber = true
opt.expandtab      = true
opt.shiftwidth     = 2
opt.tabstop        = 2
opt.smartindent    = true
opt.wrap           = false
opt.ignorecase     = true
opt.smartcase      = true
opt.splitbelow     = true
opt.splitright     = true
opt.termguicolors  = true
opt.cursorline     = true
opt.scrolloff      = 8
opt.signcolumn     = "yes"
opt.undofile       = true
opt.clipboard      = "unnamedplus"
opt.updatetime     = 200
opt.timeoutlen     = 300

-- ── Bootstrap lazy.nvim ──────────────────────────────────────
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- ── Plugins ──────────────────────────────────────────────────
require("lazy").setup({

  -- Theme: Catppuccin (great for ricing)
  { "catppuccin/nvim", name = "catppuccin", priority = 1000,
    config = function()
      require("catppuccin").setup({ flavour = "mocha", transparent_background = true })
      vim.cmd("colorscheme catppuccin")
    end },

  -- Statusline
  { "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({
        options = { theme = "catppuccin", globalstatus = true },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end },

  -- File explorer
  { "nvim-tree/nvim-tree.lua",
    keys = { { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Explorer" } },
    config = function()
      require("nvim-tree").setup({ view = { width = 32 } })
    end },

  -- Fuzzy finder
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>",  desc = "Find Files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>",   desc = "Live Grep"  },
      { "<leader>fb", "<cmd>Telescope buffers<cr>",     desc = "Buffers"    },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>",   desc = "Help Tags"  },
    },
    config = function()
      require("telescope").setup({ defaults = { layout_strategy = "horizontal" } })
    end },

  -- LSP + Mason (auto-install language servers)
  { "williamboman/mason.nvim", config = true },
  { "williamboman/mason-lspconfig.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "pyright", "bashls", "yamlls",
                             "terraformls", "dockerls", "gopls" },
        automatic_installation = true,
      })
      local lsp = require("lspconfig")
      local on_attach = function(_, bufnr)
        local map = function(k, v, d)
          vim.keymap.set("n", k, v, { buffer = bufnr, desc = d })
        end
        map("gd",         vim.lsp.buf.definition,      "Go to Definition")
        map("K",          vim.lsp.buf.hover,            "Hover Docs")
        map("<leader>ca", vim.lsp.buf.code_action,      "Code Action")
        map("<leader>rn", vim.lsp.buf.rename,           "Rename")
        map("[d",         vim.diagnostic.goto_prev,     "Prev Diagnostic")
        map("]d",         vim.diagnostic.goto_next,     "Next Diagnostic")
      end
      local servers = { "pyright", "bashls", "yamlls", "terraformls", "dockerls", "gopls" }
      for _, s in ipairs(servers) do
        lsp[s].setup({ on_attach = on_attach })
      end
      lsp.lua_ls.setup({ on_attach = on_attach,
        settings = { Lua = { diagnostics = { globals = { "vim" } } } } })
    end },

  -- Completion
  { "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",     "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      cmp.setup({
        snippet = { expand = function(a) luasnip.lsp_expand(a.body) end },
        mapping = cmp.mapping.preset.insert({
          ["<C-d>"]   = cmp.mapping.scroll_docs(-4),
          ["<C-f>"]   = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"]    = cmp.mapping.confirm({ select = true }),
          ["<Tab>"]   = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
            else fallback() end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" }, { name = "luasnip" },
        }, { { name = "buffer" }, { name = "path" } }),
      })
    end },

  -- Treesitter (syntax highlighting)
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "python", "bash", "yaml", "json",
                             "hcl", "dockerfile", "go", "markdown" },
        highlight = { enable = true },
        indent    = { enable = true },
      })
    end },

  -- Git signs in gutter
  { "lewis6991/gitsigns.nvim", config = true },

  -- Which-key (keybinding hints)
  { "folke/which-key.nvim", config = true },

  -- Autopairs
  { "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup()
    end },

  -- Comment toggling
  { "numToStr/Comment.nvim", config = true },

  -- Indent guides
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", config = true },

  -- Dashboard
  { "goolord/alpha-nvim",
    config = function()
      require("alpha").setup(require("alpha.themes.dashboard").config)
    end },

  -- Harpoon (quick file navigation — essential for infra work)
  { "ThePrimeagen/harpoon", branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ha", function() require("harpoon"):list():append() end,          desc = "Harpoon Add"  },
      { "<leader>hh", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "Harpoon Menu" },
    }},

  -- Terraform / HCL
  { "hashivim/vim-terraform" },

  -- Helm charts syntax
  { "towolf/vim-helm" },
})

-- ── Keymaps ──────────────────────────────────────────────────
local map = vim.keymap.set
map("n", "<leader>w",  "<cmd>w<cr>",          { desc = "Save" })
map("n", "<leader>q",  "<cmd>q<cr>",          { desc = "Quit" })
map("n", "<leader>bd", "<cmd>bd<cr>",         { desc = "Close Buffer" })
map("n", "<leader>nh", "<cmd>nohl<cr>",       { desc = "Clear Search" })
map("n", "<C-h>",      "<C-w>h",             { desc = "Focus Left" })
map("n", "<C-l>",      "<C-w>l",             { desc = "Focus Right" })
map("n", "<C-j>",      "<C-w>j",             { desc = "Focus Down" })
map("n", "<C-k>",      "<C-w>k",             { desc = "Focus Up" })
map("n", "<A-j>",      ":resize -2<cr>",     { desc = "Resize Down" })
map("n", "<A-k>",      ":resize +2<cr>",     { desc = "Resize Up" })
map("v", "<",          "<gv",                { desc = "Indent Left" })
map("v", ">",          ">gv",                { desc = "Indent Right" })
-- Move lines up/down
map("v", "J",          ":m '>+1<CR>gv=gv",  { desc = "Move Down" })
map("v", "K",          ":m '<-2<CR>gv=gv",  { desc = "Move Up" })
