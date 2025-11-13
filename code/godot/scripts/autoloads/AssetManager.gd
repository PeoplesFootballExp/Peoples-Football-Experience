extends Node

## ---------------------------------
## AssetManager.gd
## Handles reading, copying, and caching assets
## between res:// and user://
## ---------------------------------


enum AssetType {FLAG,TEAMLOGO,CONFEDLOGO,KIT,TOURLOGO};


# Temporary Cache: Useful for constantly changing textures but can save time for cache hits
# Sort of like a FIFO cache
const MAX_CACHE_SIZE = 200
var _temp_cache: Dictionary[String, CompressedTexture2D] = {}

# Permenent Cache,useful for consistent data for an entire scene 
var _perm_cache: Dictionary[String, CompressedTexture2D] = {}  # optional runtime cache for fast access

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
func load_asset(path: String, use_cache := false):
	if use_cache and _perm_cache.has(path):
		return _perm_cache[path]
		
	if _temp_cache.has(path):
		return _temp_cache[path]


	var res = load(path)
	if res:
		if use_cache:
			_perm_cache[path] = res
			return res
		
		if _temp_cache.size() >= MAX_CACHE_SIZE:
			var key_to_remove: String = _temp_cache.keys()[0]
			_temp_cache.erase(key_to_remove)
		_temp_cache[path] = res
			
		return res
	else:
		push_error("AssetManager: Failed to load %s" % path)
		return null


# ---------------------------------
# Preload commonly used assets on startup
# ---------------------------------
func preload_confed_logos() -> void:
	
	pass
