" ============================================
" Abréviations Go (sans plugin)
" ~/.vim/after/ftplugin/go_abbrev.vim
" ============================================

" --- Programme de base (hello world) ---
iabbrev gohello package main<CR><CR>import "fmt"<CR><CR>func main() {<CR>    fmt.Println("Hello, world")<CR>}

" --- Fonction main vide ---
iabbrev gomain func main() {<CR>    <CR>}

" --- Déclaration de variables ---
iabbrev govar var name type = value
iabbrev gosvar var name = value

" --- Déclaration de constantes ---
iabbrev goconst const Name = "value"
iabbrev goci const Name int = 42

" --- Struct de base ---
iabbrev gostruct type Name struct {<CR>    Field string<CR>}

" --- Interface de base ---
iabbrev goiface type Name interface {<CR>    Method() error<CR>}

" --- Boucle for classique ---
iabbrev gofor for i := 0; i < n; i++ {<CR>    <CR>}

" --- Boucle for range ---
iabbrev gorange for idx, val := range slice {<CR>    <CR>}

" --- Condition if ---
iabbrev goif if condition {<CR>    <CR>}

" --- Condition if/else ---
iabbrev goife if condition {<CR>    <CR>} else {<CR>    <CR>}

" --- Switch ---
iabbrev goswitch switch expr {<CR>case value:<CR>    <CR>default:<CR>    <CR>}

