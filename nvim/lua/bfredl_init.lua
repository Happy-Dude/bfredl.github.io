local first_run = not _G._bfredl
if first_run then
  _G._bfredl = {}
end
local h = _G._bfredl
local a = vim.api
local v = vim.cmd
_G._b = _G._bfredl -- for convenience
_G._a = vim.api -- S H O R T C U T to the API:s

-- test
v [[map <Plug>ch:mw <cmd>lua print("howdy")<cr>]]

require'packer'.startup(function ()
  use 'norcalli/snippets.nvim'
  use 'norcalli/nvim-colorizer.lua'

  use '~/dev/nvim-miniyank'
  use '~/dev/nvim-bufmngr'
  use '~/dev/nvim-luadev'
  use '~/dev/ibus-chords'
end)

function h.snippets_setup()
  local s = require'snippets'
  s.use_suggested_mappings()
  s.snippets = {
    _global = {
      todob = "TODO(bfredl):";
      todou = "TODO(upstream):";
      todon = "TODO(neovim):";
      f = "FIXME:";
      re = "return"; -- TODO(bfredl): redundant, integrate snippets with ibus-chords properly
    };
    lua = {
      fun = [[function $1($2)
  $0
end]];
      r = [[require]];
      l = [[local $1 = $0]];
    };
    c = {
      vp = "(void *)";
    };
  }
end

function h.xcolor()
 local out = io.popen("xcolor"):read("*a")
 return vim.trim(out)
end
v 'inoremap <F3> <c-r>=v:lua._bfredl.xcolor()<cr>'

function h.f(args)
  local b = a.nvim_create_buf(false, true)
  if args.text then
    a.nvim_buf_set_lines(b, 0, -1, true, {args.text})
  end
  local w = a.nvim_open_win(b, false, {
    relative="editor";
    width=30;
    height=1;
    row=2;
    col=2;
    style="minimal";
  })
end

function h.vimenter(startup)
  h.snippets_setup()
  if startup then
    if a.nvim__fork_serve then
      _G.prepfork = true
       a.nvim__fork_serve()
      _G.postfork = true
       -- because reasons
       a.nvim__stupid_test()
    end
  end
end

if first_run then
  vim.cmd [[autocmd VimEnter * lua _G._bfredl.vimenter(true)]]
else
  h.vimenter(false)
end
