#!/bin/bash

set -e

echo "🧠 Starting full Neovim + Catppuccin setup..."

# 1. Install Neovim and Git
echo "📦 Installing Neovim and Git..."
sudo apt update
sudo apt install -y neovim git curl unzip

# 2. Download Nerd Font (FiraCode)
echo "🔠 Installing Nerd Font (FiraCode)..."
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
curl -fLo "FiraCodeNerdFont.ttf" https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip
unzip -o FiraCode.zip -d FiraCode
rm FiraCode.zip
fc-cache -fv

# 3. Create Neovim config directory
echo "📁 Creating Neovim config directories..."
mkdir -p ~/.config/nvim/lua/plugins

# 4. Create plugin manager (lazy.nvim)
echo "📦 Installing lazy.nvim..."
LAZYPATH="$HOME/.local/share/nvim/lazy/lazy.nvim"
git clone https://github.com/folke/lazy.nvim.git --filter=blob:none "$LAZYPATH"

# 5. Create init.lua
echo "📝 Writing init.lua..."
cat <<EOF > ~/.config/nvim/init.lua
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins")
EOF

# 6. Create plugin config for Catppuccin
echo "🎨 Writing Catppuccin plugin config..."
cat <<'EOF' > ~/.config/nvim/lua/plugins/catppuccin.lua
return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    local present, catppuccin = pcall(require, "catppuccin")
    if not present then return end

    catppuccin.setup({
      flavour = "mocha",
      transparent_background = vim.g.neovide and true or false,
      show_end_of_buffer = false,
      term_colors = true,
      dim_inactive = {
        enabled = false,
        shade = "dark",
        percentage = 0.15,
      },
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
        keywords = { "italic" },
      },
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        telescope = true,
        which_key = true,
        indent_blankline = { enabled = true },
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
          },
        },
      },
      color_overrides = {
        mocha = {
          base = "#0f0f1a",
          mantle = "#13131e",
          crust = "#1a1a2b",
        },
      },
      highlight_overrides = {
        mocha = function(colors)
          return {
            TelescopeTitle       = { fg = colors.peach },
            TelescopeNormal      = { bg = "NONE" },
            TelescopeBorder      = { fg = "NONE", bg = "NONE" },
            CursorLineNr         = { fg = colors.yellow },
            LineNr               = { fg = colors.surface1 },
            VertSplit            = { fg = colors.surface0 },
            WinSeparator         = { fg = colors.surface0 },
            MsgArea              = { fg = colors.text },
            EcovimPrimary        = { fg = "#488dff" },
            EcovimSecondary      = { fg = "#FFA630" },
            EcovimHeader         = { fg = "#488dff", bold = true },
            EcovimFooter         = { fg = "#FFA630", bold = true },
            EcovimNvimTreeTitle  = { fg = "#FFA630", bg = "#16161e", bold = true },
            BufferLineFill       = { bg = "#16161E", fg = colors.surface1 },
          }
        end,
      },
    })

    vim.cmd("colorscheme catppuccin")
  end,
}
EOF

echo "✅ Setup complete! Launch Neovim and run :Lazy to install plugins."
