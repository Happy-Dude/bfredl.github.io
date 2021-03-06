local h = {}

-- def_hi {{{
-- borrowed from norcallis lua pile
function h.def_hi(group, o)
  local parts = {group}
  if o.default then table.insert(parts, "defoult") end
  if o.fg then table.insert(parts, "guifg="..o.fg) end
  if o.bg then table.insert(parts, "guibg="..o.bg) end
  if o.ctermfg then table.insert(parts, "ctermfg="..o.ctermfg) end
  if o.ctermbg then table.insert(parts, "ctermbg="..o.ctermbg) end
  if o.attr then
    table.insert(parts, "gui="..o.attr)
    table.insert(parts, "cterm="..o.attr)
  end
  if o.sp then table.insert(parts, "guisp="..o.sp) end
  if o.blend then table.insert(parts, "blend="..o.blend) end

  -- nvim.api.nvim_sett_highlig()(name, parts)
  vim.cmd ('highlight '..table.concat(parts, ' '))
end
-- }}}

h.colors = {
  darkblue = "#1a3c54";
  midblue = "#232081";
  ultragray = "#909090";
  cyanish = "#0088ff";
  cyan = "#4188ee";
  violet = "#8800ff";
}
local c = h.colors

h.basetheme = {
  -- TODO: luahl hook to interatively preview these already
  Normal = {bg=c.darkblue};
  NormalFloat = {bg=c.midblue};
  Pmenu = {bg=c.violet};
  LineNr = {fg=c.cyan};
  MsgArea = {bg=c.midblue, blend=11};
  Folded = {bg=c.ultragray, fg="#222222", attr="bold"};
}

function h.setall(theme) -- {{{
  for k,v in pairs(h.basetheme) do
    h.def_hi(k,v)
  end
end -- }}}

function h.defaults()
  h.setall(h.basetheme)
end

function h.fastmode() -- {{{
  local b = _G.bfredl
  local bb = b.a.get_current_buf()
  function _G._ccheck()
    local f = b.buf.get_lines(bb, 0, -1, true)
    local text = table.concat(f, "\n")
    local codes = loadstring(text, b.buf.get_name(bb))
    if codes then
      codes().defaults()
    end
  end

  b.exec [[
  augroup fastmode
    au InsertLeave,TextChanged <buffer>  * lua _G._ccheck()
  augroup END
  ]]
end -- }}}

-- h.fastmode()
return h
