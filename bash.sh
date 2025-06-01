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
#!/bin/bash

set -e

echo "🔄 Cleaning existing Neovim setup..."
rm -rf ~/.config/nvim ~/.local/share/nvim ~/.cache/nvim

echo "📦 Installing dependencies..."
sudo apt update
sudo apt install -y git curl unzip ripgrep fd-find build-essential python3-pip nodejs npm cargo jq libxml2-utils openssl

echo "⬇️ Installing extra tools..."
# grpcurl
go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest
# websocat
cargo install websocat

echo "🛠 Setting up Neovim plugins..."
npm i -g neovim typescript typescript-language-server eslint prettier
pip3 install pynvim

echo "🌟 Installing LazyVim starter..."
git clone https://github.com/LazyVim/starter ~/.config/nvim

echo "🧩 Adding Kulala.nvim plugin..."
cat > ~/.config/nvim/lua/plugins/kulala.lua << 'EOF'
return {
  "mistweaverco/kulala.nvim",
  keys = {
    { "<leader>Rs", desc = "Send request" },
    { "<leader>Ra", desc = "Send all requests" },
    { "<leader>Rb", desc = "Open scratchpad" },
  },
  ft = { "http", "rest" },
  opts = {
    global_keymaps = true,
    global_keymaps_prefix = "<leader>R",
    kulala_keymaps_prefix = "",
  },
}
EOF

echo "📁 Adding filetype support for .http files..."
mkdir -p ~/.config/nvim/lua/config
cat > ~/.config/nvim/lua/config/filetypes.lua << 'EOF'
vim.filetype.add({
  extension = {
    ['http'] = 'http',
  },
})
EOF

echo 'require("config.filetypes")' >> ~/.config/nvim/init.lua

echo "🚀 Launching Neovim to install plugins..."
nvim --headless "+Lazy! sync" +qa

echo "✅ Setup complete. Run Neovim with 'nvim <file>.http'"
