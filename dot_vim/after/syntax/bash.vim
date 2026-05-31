" 高亮 function 关键字
syntax keyword BashFunctionKeyword function
highlight link BashFunctionKeyword Statement

" 高亮自定义函数名 - 函数定义
syntax match BashFunctionName '\(function\s\+\)\@<=\w\+\|\w\+\(\s*()\)\@=' containedin=BashFunction
highlight link BashFunctionName Function
" 高亮自定义函数名 - 函数调用
syntax match BashFunctionCalling '^\s*\w\+' containedin=BashFunction
highlight link BashFunctionCalling Function
