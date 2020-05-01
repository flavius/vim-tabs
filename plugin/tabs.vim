command! -nargs=0 TabHistoryGotoNext call tabs#GoToNext()
command! -nargs=0 TabHistoryGotoPrev call tabs#GoToPrev()
command! -nargs=0 TabHistoryClear call tabs#ClearHistory()
command! -nargs=0 TabHistoryList call tabs#List()

autocmd BufEnter * call tabs#OnBufVisible(expand('<abuf>') + 0)
autocmd BufDelete * call tabs#OnBufDeleted(expand('<abuf>') + 0)
autocmd BufWipeout * call tabs#OnBufDeleted(expand('<abuf>') + 0)
autocmd FileType * call tabs#FilterFileTypes(expand('<abuf>') + 0)
