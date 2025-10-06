#!/usr/bin/env bash
set -euo pipefail

# Detect package manager
detect_pkg_manager() {
  if command -v brew &>/dev/null; then
    echo "brew"
  elif command -v dnf &>/dev/null; then
    echo "dnf"
  elif command -v apt-get &>/dev/null; then
    echo "apt"
  else
    echo "unsupported"
  fi
}

install_packages() {
  local pkgs=(
    zsh
    jq
    yq
    vim
    tmux
    ripgrep
    fzf
    lazygit
    neovim
    git-delta
  )
  local pkg_mgr
  pkg_mgr=$(detect_pkg_manager)

  case "$pkg_mgr" in
    brew)
      echo "Using Homebrew..."
      brew update
      brew install "${pkgs[@]}"
      ;;
    dnf)
      echo "Using DNF..."
      sudo dnf install -y "${pkgs[@]}"
      ;;
    apt)
      echo "Using APT..."
      sudo apt-get update -y
      sudo apt-get install -y "${pkgs[@]}"
      ;;
    *)
      echo "❌ Error: No supported package manager found (brew, dnf, apt-get)" >&2
      exit 1
      ;;
  esac
}

install_oh_my_zsh() {
  local oh_my_zsh_dir="$HOME/.oh-my-zsh"

  if [ -d $oh_my_zsh_dir ]; then
    echo "$oh_my_zsh_dir already exists, skipping install..."
  else
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi
}

install_zsh_syntax_highlightning() {
  local dir="$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
  if [ -d $dir ]; then
    echo "$dir already exists, skipping install..."
  else
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $dir
  fi
}

link_dotfiles() {
  local dotfiles_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
  echo "🔗 Linking dotfiles from $dotfiles_dir..."

  # List of files/dirs to symlink
  files=(
    .gitconfig
    .zshrc
    .vimrc
    .tmux.conf
    .scripts
    .config/aerospace
    .config/ghostty
    .config/lazygit
    .config/nvim
    .config/zshrc.d
  )

  for file in "${files[@]}"; do
    target="$HOME/$file"
    source="$dotfiles_dir/$file"

    if [ -e "$target" ] || [ -L "$target" ]; then
      echo "$target already exists, skipping linking..."
    else
      echo "✅ Linking $target → $source"
      ln -s "$source" "$target"
    fi
  done

  # Make everything in .scripts executable
  if [ -d "$dotfiles_dir/.scripts" ]; then
    echo "🔧 Making scripts in $HOME/.scripts executable..."
    chmod +x "$HOME/.scripts"/* || true
  fi
}

git submodule update --init --recursive
install_packages
install_oh_my_zsh
install_zsh_syntax_highlightning
link_dotfiles

echo "🎉 Setup complete!"

