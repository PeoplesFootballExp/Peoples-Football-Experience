extends Node

## ---------------------------------
## AssetManager.gd
## Handles reading, copying, and caching assets
## between res:// and user://
## ---------------------------------


enum AssetType {FLAG,TEAMLOGO,CONFEDLOGO,KIT,TOURLOGO};



var cache := {}  # optional runtime cache for fast access

# ---------------------------------
# Move an asset from res:// to user:// (e.g., database, save files)
# ---------------------------------
func move_to_user(path_res: String, type: AssetType, overwrite := false) -> String:
	var filename = path_res.get_file()
	var user_path = "user://%s" % filename

	if FileAccess.file_exists(user_path) and not overwrite:
		return user_path

	var src = FileAccess.open(path_res, FileAccess.READ)
	if not src:
		push_error("AssetManager: could not open %s" % path_res)
		return ""

	var dst = FileAccess.open(user_path, FileAccess.WRITE)
	dst.store_buffer(src.get_buffer(src.get_length()))
	src.close()
	dst.close()

	print("Moved asset to user:// -> %s" % filename)
	return user_path


# ---------------------------------
# Load a resource (cached optional)
# ---------------------------------
func load_asset(path: String, use_cache := true):
	if use_cache and cache.has(path):
		return cache[path]

	var res = load(path)
	if res:
		if use_cache:
			cache[path] = res
		return res
	else:
		push_error("AssetManager: Failed to load %s" % path)
		return null


# ---------------------------------
# Preload commonly used assets on startup
# ---------------------------------
func preload_essentials():
	cache["logo"] = load("res://ui/logo.png")
	cache["font_main"] = load("res://fonts/main_font.tres")
	cache["theme_dark"] = load("res://themes/dark_theme.tres")
	cache["theme_light"] = load("res://themes/light_theme.tres")
	print("AssetManager: Essentials preloaded.")
