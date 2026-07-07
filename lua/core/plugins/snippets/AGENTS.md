# Snippets

The snippet engine used here is **LuaSnip**.

## LuaSnip Documentation Reference

Source: https://raw.githubusercontent.com/L3MON4D3/LuaSnip/refs/heads/master/DOC.md

### Common imports

```lua
local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local extras = require("luasnip.extras")
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
```

### Node types

| Node | Constructor | Purpose |
|------|-------------|---------|
| TextNode | `t(text)` | Static text |
| InsertNode | `i(jump_idx, default_text)` | Editable placeholder / tabstop |
| FunctionNode | `f(fn, argnodes, opts)` | Text derived from other nodes |
| ChoiceNode | `c(jump_idx, choices)` | Switch between alternatives |
| SnippetNode | `sn(jump_idx, nodes)` | Nest a group of nodes |
| IndentSnippetNode | `isn(jump_idx, nodes, indent)` | Nested nodes with custom indent |
| DynamicNode | `d(jump_idx, fn, argnodes, opts)` | Generate a snippetNode at runtime |
| RestoreNode | `r(jump_idx, key, nodes)` | Store/restore user input across updates |

### Adding snippets

```lua
ls.add_snippets("lua", {
  s("trig", { t("hello"), i(1, "world") })
})

-- available in all filetypes
ls.add_snippets("all", { ... })
```

### Jump-index rules

- Nodes are visited in order `1, 2, ..., n, 0`.
- Jump-indices **restart at 1** inside each nested `snippetNode` (unlike TextMate snippets).
- An `i(0)` marks the final cursor position; one is auto-inserted if omitted.

### FunctionNode example

```lua
s("trig", {
  i(1), t" -> ",
  f(function(args) return "[" .. args[1][1] .. "]" end, { 1 })
})
```

### ChoiceNode example

```lua
s("trig", c(1, {
  t("option A"),
  i(nil, "editable option B"),
  sn(nil, { t("nested: "), i(1) }),
}))
```

### DynamicNode example

```lua
s("trig", {
  i(1, "input"),
  d(2, function(args)
    return sn(nil, { i(1, args[1]) })
  end, { 1 })
})
```

### Key indexer (cross-parent references)

```lua
s("trig", {
  i(1, "", { key = "root" }),
  c(2, {
    sn(nil, {
      f(function(args) return args[1] end, k("root"))
    })
  })
})
```

### Autosnippets

```lua
s({ trig = "trig", snippetType = "autosnippet" }, { t("auto-expanded") })
-- requires: ls.config.setup({ enable_autosnippets = true })
```

### Loaders

LuaSnip can load snippets from files. Snippets in this directory are loaded via the Lua loader:

```lua
require("luasnip.loaders.from_lua").load({ paths = { "<path-to-snippets>" } })
```
