" ============================================
" Abréviations C
" ============================================

" Hello world
iabbrev chello #include <stdio.h><CR><CR>int main() {<CR>    printf("Hello, world\n");<CR>    return 0;<CR>}

" Fonction main
iabbrev cmain int main() {<CR>    return 0;<CR>}

" Variable
iabbrev cvar int varname = 0;

" Constante
iabbrev cconst #define NAME 42

" For loop
iabbrev cfor for (int i = 0; i < n; i++) {<CR>    <CR>}

" While loop
iabbrev cwhile while (condition) {<CR>    <CR>}

" If / else
iabbrev cif if (condition) {<CR>    <CR>}
iabbrev cife if (condition) {<CR>    <CR>} else {<CR>    <CR>}

