-- Declare the LazyVim extras here, not in lazyvim.json. The :LazyExtras
-- command writes that file. Git ignores it, because LazyVim also keeps local
-- state in it.
--
-- The macOS config declares the same extras in lua/config/lazy.lua. This
-- config cannot do that. Omarchy owns lazy.lua, and init.lua reads it from
-- /usr/share/omarchy-nvim/config. A spec file under lua/plugins/ keeps the
-- Omarchy file unforked.
return {
  { import = "lazyvim.plugins.extras.editor.neo-tree" },
  { import = "lazyvim.plugins.extras.editor.snacks_picker" },
}
