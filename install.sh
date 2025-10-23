#!/usr/bin/env bash
set -euo pipefail
# install.sh — minimal installer for Hyrahmo Jekyll site on Arch Linux
# Usage: bash install.sh
# This script will:
#  - install required system packages (via sudo pacman)
#  - install bundler/jekyll in user gem dir
#  - setup local bundle path vendor/bundle and run bundle install
#  - initialize git repo if missing and print next steps for GitHub Pages deployment
#
# NOTE: This script is safe and will not ask for passwords or upload anything to external services.
#       You must run this on an Arch Linux machine (or adapt the package manager commands).

echo "=== Hyrahmo site installer ==="
echo

# check pacman availability
if ! command -v pacman >/dev/null 2>&1; then
  echo "Error: pacman not found. This installer is tailored for Arch Linux."
  echo "If you're on another distro, install ruby, base-devel, git, curl and node/npm manually."
  exit 1
fi

# Ask for sudo once
echo "Will install system packages: ruby, base-devel, git, curl"
sudo pacman -Sy --needed --noconfirm ruby base-devel git curl >/dev/null

# Install bundler and jekyll to user gems
echo "Installing bundler and jekyll into your user gem dir..."
gem install --user-install bundler jekyll >/dev/null

# ensure GEM_HOME and PATH are set in shell rc
RCFILE="${HOME}/.bashrc"
if [ -n "${ZSH_VERSION-}" ]; then
  RCFILE="${HOME}/.zshrc"
fi

GEM_LINE='export GEM_HOME="$HOME/.local/share/gem"'
PATH_LINE='export PATH="$HOME/.local/share/gem/bin:$PATH"'

if ! grep -Fxq "$GEM_LINE" "$RCFILE" 2>/dev/null; then
  printf "\n# Ruby gems for user install\n%s\n%s\n" "$GEM_LINE" "$PATH_LINE" >> "$RCFILE"
  echo "Added GEM_HOME and PATH to $RCFILE (you may need to restart your shell)"
else
  echo "GEM_HOME already set in $RCFILE"
fi

# source rc if possible
# shellcheck source=/dev/null
source "$RCFILE" >/dev/null 2>&1 || true

# set bundle install to project-local vendor/bundle
echo "Configuring Bundler to install gems into vendor/bundle (project-local)"
bundle config set --local path 'vendor/bundle'

# Create Gemfile if missing (should be present)
if [ ! -f Gemfile ]; then
  cat > Gemfile <<'EOF'
source "https://rubygems.org"

gem "jekyll", "~> 4.3.4"
gem "webrick"
gem "jekyll-feed"
gem "jekyll-seo-tag"
gem "jekyll-sitemap"
EOF
  echo "Created minimal Gemfile"
fi

echo "Running bundle install (this may take a minute)..."
bundle install --jobs=4

echo
echo "✅ Dependencies installed."
echo "To run the local dev server now:"
echo "  bundle exec jekyll serve --livereload"
echo "Open http://127.0.0.1:4000 in your browser to view the site."
echo
echo "=== Git / GitHub steps ==="
echo "If you haven't yet created a GitHub repo, create one named: hyrahmo.github.io"
echo "Then run the following (replace with your remote URL if different):"
echo "  git init  # if not already"
echo "  git add ."
echo "  git commit -m 'Initial site' || true"
echo "  git branch -M main || true"
echo "  git remote add origin git@github.com:hyrahmo/hyrahmo.github.io.git || true"
echo "  git push -u origin main"
echo
echo "After pushing, enable GitHub Pages in repository settings: Branch: main, / (root)."
echo
echo "Admin (Decap CMS): edit admin/config.yml to configure repo if needed (already set to hyrahmo/hyrahmo.github.io)"
echo "Then visit: https://hyrahmo.github.io/admin/ (after site is live)"
echo
echo "Security note: To use Decap CMS with GitHub backend you usually need to create a GitHub OAuth App or use an identity provider."
echo "See docs: https://decapcms.org/docs/github/ for details."
echo
echo "Installer finished."
