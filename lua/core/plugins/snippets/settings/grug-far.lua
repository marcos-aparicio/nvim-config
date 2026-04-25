local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

-- Non-greedy regex snippet
-- ng keybinding produces: [^<character>]*<character>
-- where the second character matches the first automatically
ls.add_snippets("grug-far", {
  s(
    { trig = "ng", wordTrig = false, regTrig = false },
    {
      t("[^"),
      i(1, "x"),
      t("]*"),
      f(function(args)
        return args[1][1]
      end, { 1 }),
    }
  ),
})
