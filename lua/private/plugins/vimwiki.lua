local wiki_paths = {
	{
		path = os.getenv("HOME") .. "/Obsidian/obsidian/M",
		name = "Main",
	},
	{
		path = os.getenv("HOME") .. "/Obsidian/obsidian/D",
		name = "Denisse",
	},
	{
		path = os.getenv("HOME") .. "/Obsidian/obsidian/W",
		name = "Work",
	},
	{
		path = os.getenv("HOME") .. "/Obsidian/obsidian/T",
		name = "Tickler",
	},
	{
		path = os.getenv("HOME") .. "/Obsidian/obsidian/P",
		name = "Reference: Progra",
	},
	{
		path = os.getenv("HOME") .. "/Obsidian/project_reference/college",
		name = "Project Reference: College",
	},
	{
		path = os.getenv("HOME") .. "/Obsidian/project_reference/work",
		name = "Project Reference: Work",
	},
	{
		path = os.getenv("HOME") .. "/Obsidian/project_reference/personal",
		name = "Project Reference: Personal",
	},
}
return wiki_paths
