set runtimepath+=~/.config/vim_runtime
set ignorecase
set hlsearch
let g:powerline_pycmd="py3"
source ~/.config/vim_runtime/vimrcs/basic.vim
source ~/.config/vim_runtime/vimrcs/filetypes.vim
source ~/.config/vim_runtime/vimrcs/plugins_config.vim
source ~/.config/vim_runtime/vimrcs/extended.vim

try
source ~/.config/vim_runtime/my_configs.vim
catch
endtry
