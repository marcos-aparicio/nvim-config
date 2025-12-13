local prequire = require("utils").prequire
local ls = prequire("luasnip")
if not ls then
  return
end

local s, t, f = ls.snippet, ls.text_node, ls.function_node

local function create_smart_snippets(trigger, text)
  return {
    s(trigger, { t(text) }),
    s("," .. trigger, { t("> " .. text) })
  }
end

local copilot_chat_snippets = {}

-- Add all snippets for each trigger
local trigger_snippets = {
  { "bfvs",  "#buffer:active" },
  { "bfall", "#buffer:listed" },
  { "son4",  "$claude-sonnet-4" },
  { "arb",   "#dir_tree" },
  { "obs",   "@obsidian" },
  { "daisy", "#url:https://daisyui.com/llms.txt" },
}

for _, trigger_data in ipairs(trigger_snippets) do
  local trigger, text = trigger_data[1], trigger_data[2]
  local snippets = create_smart_snippets(trigger, text)
  for _, snippet in ipairs(snippets) do
    table.insert(copilot_chat_snippets, snippet)
  end
end


local static_snippets = {
  s(",gitcom", {
    t({
      "#gitdiff:static",
      "/Commit",
      "Please use the @git_git_commit tool for creating a commit based on the output that you create"
    }),
  }),
  s(",gitsus",{
    t({
      "#gitdiff:staged",
      "Write commit message for the change with commitizen convention. I want this commit message to only include a title. Keep the title under 50 characters",
      "Please use the @git_git_commit tool for creating a commit based on the output that you create"
    })
  })
}

local combined_snippets = vim.tbl_extend("force", copilot_chat_snippets, static_snippets)

ls.add_snippets("copilot-chat", combined_snippets)
