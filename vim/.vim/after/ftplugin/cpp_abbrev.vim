" ============================================
" Abréviations C++
" ============================================

" Hello world
iabbrev cpphello #include <iostream><CR>using namespace std;<CR><CR>int main() {<CR>    cout << "Hello, world" << endl;<CR>    return 0;<CR>}

" Fonction main
iabbrev cppmain int main() {<CR>    return 0;<CR>}

" Classe
iabbrev cppclass class ClassName {<CR>public:<CR>    ClassName() {}<CR>    ~ClassName() {}<CR>};

" Variable
iabbrev cppvar int varname = 0;

" Constante
iabbrev cppconst const int NAME = 42;

" For loop
iabbrev cppfor for (int i = 0; i < n; i++) {<CR>    <CR>}

" While loop
iabbrev cppwhile while (condition) {<CR>    <CR>}

" If / else
iabbrev cppif if (condition) {<CR>    <CR>}
iabbrev cppife if (condition) {<CR>    <CR>} else {<CR>    <CR>}

