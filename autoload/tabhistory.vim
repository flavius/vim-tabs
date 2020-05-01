" =============================================================================
" Public API
" =============================================================================
" Go to the next-higher buffer number
function! tabhistory#GoToNext()
    let visited_bufs = s:GetSortedBuffersOfTab(tabpagenr())
    let current_buf = str2nr(bufnr())
    let current_pos = index(visited_bufs, current_buf)
    if current_pos == -1
        echom "Current buffer not found. Please report a bug."
        return
    endif
    if current_pos == len(visited_bufs)-1
        let new_buffer_pos = 0
    else
        let new_buffer_pos = current_pos + 1
    endif
    execute "buffer" visited_bufs[new_buffer_pos]
endfunction

" Go to the previous buffer by number
function! tabhistory#GoToPrev()
    let visited_bufs = s:GetSortedBuffersOfTab(tabpagenr())
    let current_buf = str2nr(bufnr())
    let current_pos = index(visited_bufs, string(current_buf))
    if current_pos == -1
        return
    endif
    if current_pos == 0
        let new_buffer_pos = len(visited_bufs)-1
    else
        let new_buffer_pos = current_pos - 1
    endif
    execute "buffer" visited_bufs[new_buffer_pos]
endfunction

function! tabhistory#List()
    let tabnr = tabpagenr()
    let visited_bufs = gettabvar(tabnr, 'visited_bufs', {})
    let cwd = getcwd(-1, tabnr)
    let cwdlen = len(cwd)
    echom printf("%7s %7s %s", "Buffer", "Visits", "   File relative to " . cwd)
    for bufnr in keys(visited_bufs)
        " if !s:BufferIsListed(bufnr)
        "     continue
        " endif
        let info = getbufinfo(bufnr+0)[0]
        if has_key(info, 'variables')
            unlet info['variables']
        endif
        if has_key(info, 'signs')
            unlet info['signs']
        endif
        let vis_count = visited_bufs[bufnr]
        let name = info['name'][cwdlen+1:]
        echom printf("%7d %7d    %5s", bufnr, vis_count, name)
        "echom bufnr . "      visited " . vis_count . "        " . info['name'] . "       info " . string(info)
    endfor
endfunction

function! tabhistory#ClearHistory()
    let tabnr = tabpagenr()
    let visited_bufs = s:GetSortedBuffersOfTab(tabnr)
    for bufnr in visited_bufs
        call s:DeleteFromTabHistory(tabnr, bufnr)
    endfor
endfunction

" =============================================================================
" Helper functions
" =============================================================================
function! s:GetSortedBuffersOfTab(tabnr)
    let visited_bufs = gettabvar(a:tabnr, 'visited_bufs', {})
    let visited_bufs = keys(visited_bufs)
    let t = map(visited_bufs, {k, v -> str2nr(v) })
    return sort(t)
endfunction

function! s:BufferIsListed(bufnr)
    let info = getbufinfo(a:bufnr + 0)
    if !len(info)
        return v:false
    endif
    if info[0].listed == 1
        return v:true
    endif
    return v:false
endfunction

function! s:DeleteFromTabHistory(tabnr, bufnr)
    let visited_bufs = gettabvar(a:tabnr, 'visited_bufs', {})
    if has_key(visited_bufs, a:bufnr)
        unlet visited_bufs[a:bufnr]
        call settabvar(a:tabnr, 'visited_bufs', visited_bufs)
    endif
endfunction

function! s:DeleteFromAllTabHistory(bufnr)
    for tabnr in range(1, tabpagenr('$'))
        call s:DeleteFromTabHistory(tabnr, a:bufnr)
    endfor
endfunction!

" =============================================================================
" Event handlers
" =============================================================================
function! tabhistory#OnBufVisible(bufnr)
    if !s:BufferIsListed(a:bufnr + 0)
        return
    endif
    if !has_key(t:visited_bufs, a:bufnr+0)
        let t:visited_bufs[a:bufnr+0] = 0
    endif
    let t:visited_bufs[a:bufnr+0] = t:visited_bufs[a:bufnr+0] + 1
    let info = getbufinfo(a:bufnr+0)[0]
    unlet info['variables']
    let tabnr = tabpagenr()
    let name = fnamemodify(info['name'], ':t')
endfunction

function! tabhistory#OnBufDeleted(bufnr)
    if !s:BufferIsListed(a:bufnr+0)
        return
    endif
    call s:DeleteFromAllTabHistory(a:bufnr)
    let tabnr = tabpagenr()
    " echom "buffer deleted " . a:bufnr . ' tab: ' . tabnr . ' visited: ' . string(t:visited_bufs)
endfunction

function! tabhistory#FilterFileTypes(bufnr)
    let ft = getbufvar(a:bufnr, '&filetype')
    if (index([], ft) >= 0)
        call s:DeleteFromAllTabHistory(a:bufnr)
    endif
    if !s:BufferIsListed(a:bufnr + 0)
        call s:DeleteFromAllTabHistory(a:bufnr)
    endif
endfunction

autocmd BufEnter * call tabhistory#OnBufVisible(expand('<abuf>') + 0)
autocmd BufDelete * call tabhistory#OnBufDeleted(expand('<abuf>') + 0)
autocmd BufWipeout * call tabhistory#OnBufDeleted(expand('<abuf>') + 0)
autocmd FileType * call tabhistory#FilterFileTypes(expand('<abuf>') + 0)
