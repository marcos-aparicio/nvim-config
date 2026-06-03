# Collections

## What are Collections?

**Collections** are organized directories of markdown files managed through a unified system in the markdown plugin. They allow you to create, browse, and optionally index different types of content with consistent workflows.

Each collection:
- Lives in its own directory (e.g., `lists/`, `routines/`, `random/`)
- Can be created, opened, and browsed via keymaps
- Has optional features: telescope browsing, automatic indexing
- Uses consistent naming (spaces → dashes, lowercase)

## Available Collections

### Lists
- **Directory**: `lists/`
- **Features**: Telescope browsing, auto-indexing
- **Purpose**: Project lists (next, someday-maybe, inbox, waiting-to, tickler)
- **Keymaps**:
  - `<leader>nl` - Browse all lists (telescope)
  - `<leader>na` - Create new list
  - `<leader>nn` - Open "next" list
  - `<leader>ns` - Open "someday-maybe" list
  - `<leader>nw` - Open "waiting-to" list
  - `<leader>ni` - Open "inbox" list
  - `<leader>nt` - Open "tickler" list
  - `<leader>ii` - Add item to inbox
  - `<leader>il` - View lists index

### Routines
- **Directory**: `routines/`
- **Features**: Telescope browsing, auto-indexing
- **Purpose**: Daily/periodic routines and checklists
- **Keymaps**:
  - `<leader>rl` - Browse all routines (telescope)
  - `<leader>ra` - Create new routine
  - `<leader>ir` - View routines index

### Random
- **Directory**: `random/`
- **Features**: Telescope browsing (no indexing)
- **Purpose**: Random notes, ideas, or loose ends
- **Keymaps**:
  - `<leader>r` - Browse all random entries (telescope)
  - Add new random entry keymap (to be configured)

## Adding a New Collection

To add a new collection:

1. **Define the collection config** in `collections.lua`:
```lua
collections_config.my_collection = {
  dir_name = "my_collection",
  has_index = true,  -- or false if no indexing needed
  index_module = "core.plugins.markdown.my-collection-index",  -- only if has_index = true
}
```

2. **Create an index module** (if `has_index = true`):
   - Create `my-collection-index.lua` with a `regenerate_index()` function
   - Reference the lists-index.lua or routines-index.lua as templates

3. **Add keymaps** in `keymaps.lua`:
```lua
vim.keymap.set("n", "<leader>my", function()
  collections.open_telescope("my_collection")
end, { buffer = true, desc = "Browse my collection" })

vim.keymap.set("n", "<leader>mya", function()
  collections.create_new_entry("my_collection")
end, { buffer = true, desc = "Create new entry in my collection" })
```

## How Collections Work

### Creating an Entry
1. User triggers create keymap (e.g., `<leader>na`)
2. Prompted for entry name
3. Name is transformed: trimmed, lowercased, spaces → dashes
4. File created with H1 header using original name
5. File opened in editor
6. Index regenerated (if collection has indexing)

### Browsing with Telescope
1. User triggers browse keymap (e.g., `<leader>nl`)
2. Telescope opens filtered to collection directory
3. User can fuzzy-find and open any file

### Auto-Indexing
- Whenever a new entry is created, the index automatically regenerates
- Maintains wiki-links to all entries organized by sections
- "Other" section captures entries not in manual sections

## Implementation Details

### collections.lua
Provides the core functionality:
- `open_telescope(collection_name)` - Browse collection with telescope
- `create_new_entry(collection_name)` - Create new entry
- `open_file(collection_name, filename)` - Open specific file

### Per-Collection Modules (Optional)
- `lists.lua` - Convenience functions for specific lists (next, someday-maybe, etc.)
- `routines.lua` - Convenience functions for routines
- Each maps to the generalized collections API

### Index Modules (Optional)
- `lists-index.lua` - Maintains `indexes/lists.md`
- `routines-index.lua` - Maintains `indexes/routines.md`
- Each implements `regenerate_index()`

## Example Workflow

**Creating a "project-ideas" collection:**

1. Add config in `collections.lua`:
```lua
collections_config.project_ideas = {
  dir_name = "project_ideas",
  has_index = false,  -- Simple browsing only
}
```

2. Add keymaps in `keymaps.lua`:
```lua
vim.keymap.set("n", "<leader>pi", function()
  collections.open_telescope("project_ideas")
end, { buffer = true, desc = "Browse project ideas" })

vim.keymap.set("n", "<leader>pia", function()
  collections.create_new_entry("project_ideas")
end, { buffer = true, desc = "Create new project idea" })
```

3. Done! Users can now:
   - `<leader>pia` - Create new project idea
   - `<leader>pi` - Browse all project ideas
   - Files auto-named: "Cool AI Tool" → `cool-ai-tool.md`
