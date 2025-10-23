Hyrahmo Jekyll template (minimal)

How to use (local on Arch Linux):
1. Install Ruby, Bundler, Node/npm (shown below)
   sudo pacman -Syu ruby ruby-bundler nodejs npm
2. Install gems and run Jekyll:
   gem install bundler jekyll
   bundle exec jekyll serve
3. For full Tailwind support, integrate PostCSS/Tailwind locally.

Notes:
- Edit admin/config.yml to set your GitHub repo for Decap CMS.
- English pages are under /en/.
