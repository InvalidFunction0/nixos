if exists("g:loaded_toggle") | finish | endif

let Toggle = luaeval("require('toggle').toggleBool")

command! -nargs=* ToggleBool call Toggle()

let g:loaded_toggle = 1
