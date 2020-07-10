function! s:TestFunction()
  let tab1 = tabpagenr()+1
  let buf1 = bufnr('$')+1
  messages clear
  tabnew
  TabHistoryList
  let messages = split(execute('messages'), '\n')
  messages clear
  tabclose
  call testify#assert#matches(messages[1], 'Buffer\s\+Visits\s\+File relative to\s\+')
  call testify#assert#matches(messages[2], '\s\+'.buf1.'\s\+1\s\+')
endfunction

call testify#it('Create new tab and list the only buffer in it', function('s:TestFunction'))
