#!/usr/bin/env ruby
# vim: ft=ruby

# from: http://tammersaleh.com/posts/the-modern-vim-config-with-pathogen

git_bundles = [ 
  "git://github.com/gmarik/snipmate.vim.git",
  "git://github.com/vim-scripts/pathogen.vim.git",
  "git://github.com/vim-scripts/ack.vim.git",
  "git://github.com/vim-scripts/cucumber.zip.git",
  "git://github.com/vim-scripts/fugitive.vim.git",
  "git://github.com/vim-scripts/git.zip.git",
  "git://github.com/vim-scripts/Haml.git",
  "git://github.com/vim-scripts/Markdown.git",
  "git://github.com/vim-scripts/ragtag.vim.git",
  "git://github.com/vim-scripts/rails.vim.git",
  "git://github.com/vim-scripts/repeat.vim.git",
  "git://github.com/vim-scripts/surround.vim.git",
  "git://github.com/vim-scripts/vividchalk.vim.git",
  "git://github.com/vim-scripts/Align.git",
  "git://github.com/vim-scripts/SuperTab.git",
  "git://github.com/vim-scripts/tComment.git",
  "git://github.com/vim-scripts/FuzzyFinder",
  "git://github.com/vim-scripts/Command-T.git",
  "git://github.com/vim-scripts/ZoomWin.git",
  "git://github.com/vim-scripts/Gist.vim",
  "git://github.com/vim-scripts/jQuery.git",
  "git://github.com/vim-scripts/file-line.git",
  "git://github.com/vim-scripts/IndexedSearch",
]


require 'fileutils'

bundle_dir = File.expand_path('../bundle/', __FILE__)

git_bundles.each do |url|
  dirname = File.basename(url)
  puts "* Unpacking #{url} into #{dirname}"
  dir = File.join(bundle_dir, dirname)
  `cd #{dir} 2>/dev/null && git pull || git clone #{url} #{dir}`
end
