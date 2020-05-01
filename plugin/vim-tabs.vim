command! -nargs=0 TabHistoryGotoNext call tabhistory#GoToNext()
command! -nargs=0 TabHistoryGotoPrev call tabhistory#GoToPrev()
command! -nargs=0 TabHistoryClear call tabhistory#ClearHistory()
command! -nargs=0 TabHistoryList call tabhistory#List()
