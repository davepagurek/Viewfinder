if exists("g:loaded_viewfinder") || &cp
  finish
endif
let g:loaded_viewfinder=1
let s:keepcpo=&cpo
set cpo&vim

function! s:Find(expression)
    " Find matching files
    let l:list=split(system("grep -rlw . -e '".a:expression."'"), "[\n]")

    " Remove dotfiles
    call filter(l:list, 'v:val =~ "/[^.][^/]*$"')

    " Display options
    let l:items=len(l:list)
    if l:items==0
        echo "No results found."
        return
    endif
    for l:i in range(0, l:items-1)
        echo "".l:i+1."\t".l:list[l:i]
    endfor

    " Get user input
    call inputsave()
    let l:input=input("Which? (RETURN to cancel)\n")
    call inputrestore()

    " Validate user input
    if strlen(l:input)==0
        return
    endif
    if strlen(substitute(l:input, "[0-9]", "", "g"))>0
        echo "Not a number"
        return
    endif
    if l:input<1 || l:input>l:items
        echo "Out of range"
        return
    endif

    " Open file
    execute ":e ".l:list[l:input-1]
endfunction
command! -nargs=1 Find call <SID>Find(<q-args>)
