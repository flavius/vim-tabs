# Why it matters?
Productivity in vim matters.

# What it does

It helps you use tabs correctly and productively.

This plugin is a work in progress, but it introduces the notion of "context",
or "logical view" which, when paired with vim tabs, can be very powerful.

In short:

- a context is a logical view of your code, a cut through a smaller subset of
    your buffers
- contexts can be nested
- you can work with multiple contexts in parallel
- you can work on the same file from different contexts
- in vim, one context is represented by exactly one tab
- "context thinking" can help resolve complex merge conflicts

A lot of productivity features are planned. See issues for a list.

# Why this plugin?

Whenever beginners or somewhat routined vimmers find out about tabs, they
attempt to use tabs as windows. When they ask for help about managing their
tabs, they are told by seasoned users that they're doing it wrong.

The correct way to use tabs is to use one tab per logical context.

But what is a logical context?

Let's have a look at a hypothetical directory structure 

```

 ── project-root
    ├── main.txt
    ├── A
    │   └── B
    │       ├── cd.txt
    │       ├── C
    │       │   ├── b.txt
    │       │   └── a.txt
    │       └── D
    │           └── c.txt
    └── X
        └── Y
            ├── ab.txt
            └── Z
                ├── b.txt
                └── a.txt

```


In one logical view you might be editing just the files `a.txt` and `b.txt`.

Note: The directory `C` has just two files for brevity, but it could have more
files and directories inside.

The working directory of this logical view might sense to be the directory
`C`.


In another logical view you could be editing just file `c.txt`, but
semantically, let's suppose it would make sense to also edit `cd.txt` in this
view. For this reason, the working directory of this view would be the entire
directory `B`.

You might then argue that the first logical view is a subset of the second
view - and you might be right, but maybe also not! It depends on the criteria
you use to group files. Maybe from the architectural standpoint it makes sense
to group them differently - for the task at hand.

A logical view is a (semantic) lens through which you look at your project and
what lenses you define depends heavily on the project. Fact is, in reasonably
sized projects, you will need this lensing because of the rigidity of the
filesystem.

If a feature request comes in, and the changes you need to make have ripple
effects throughout the architecture, it might make sense to have three logical
views:

  1. `a.txt`, `b.txt` CWD: `C` - for implementation details of subsystem `C`
  2. `c.txt`, `cd.txt`, CWD: `B` - for implementation details of subsystem `B`
  3. `main.txt`, `cd.txt`, `ab.txt`, CWD: `project-root` - for the topmost
     integration level

You might have to switch constantly between the three logical views, and
having each of them available in its own tab can help you move around faster
with less cognitive load.

Note: the file `cd.txt` is loaded in two logical views simultaneously.
Note: CWD stands for current working directory (of the view/tab).

Please notice the MIGHT in the above example. It might be a good approach! But
it can also be that you realize that in fact you're moving a lot between the
files `a.txt`, `ab.txt` and `main.txt`. In this case, maybe it's best to
define a new logical view with these files, so that you move between them
quickly.

# Installation

## Vim's package manager

Text

## Pathogen

Text

## Vundle

Text


# Provided commands

Keep in mind that this is a working in progress and things might change - but
I'm trying to keep the "public API" as stable as possible.

That being said, the commands are currently:

- `TabHistoryGotoNext`
- `TabHistoryGotoPrev`
- `TabHistoryClear`
- `TabHistoryList`

With much more being planned!

My mappings are for instance

```
nnoremap <silent> <Leader>tn :TabHistoryGotoNext<CR>
nnoremap <silent> <Leader>tp :TabHistoryGotoPrev<CR>
nnoremap <silent> <Leader>tc :TabHistoryClear<CR>
nnoremap <silent> <Leader>tl :TabHistoryList<CR>
```

# Relevant vim settings, commands and other plugins, and requirements

- `autochdir` - should not be used, because it constraints the `CWD` too much, and
    thus the files which you can load with ease
- `set hidden` - must be set, so that you can hide buffers, while loading
    different ones in the current window
- `vim-rooter` - must have its chdir feature disabled
- `tcd` - is vital, use it. If you start a tab with a file at the root of the new
    context, you can change the directory with `tcd %:p:h`
- use marks and other motions! See `:help motions.txt`

This plugin is best used with other productivity plugins:

- `CtrlP` - find files only in the current context
- `taboo.vim` - give the tab a meaningful name
- `startify` - easily resume your work on your contexts by using sessions
- `floaterm` - start a shell in the current context
- `NERDTree` - browse files in the current context, when you don't know what to
    search for with `CtrlP`
