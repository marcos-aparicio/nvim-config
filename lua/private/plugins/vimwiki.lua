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
		path = os.getenv("HOME") .. "/Obsidian/obsidian/C",
		name = "College",
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
		name = "Prj: College",
	},
	{
		path = os.getenv("HOME") .. "/Obsidian/project_reference/work",
		name = "Prj: Work",
	},
	{
		path = os.getenv("HOME") .. "/Obsidian/project_reference/personal",
		name = "Prj: Personal",
	},
	{
		path = os.getenv("HOME") .. "/Obsidian/Diary",
		name = "Diary",
	},
}
return wiki_paths
