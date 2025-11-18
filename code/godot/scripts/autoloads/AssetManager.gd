extends Node

## ---------------------------------
## AssetManager.gd
## Handles reading, copying, and caching assets
## between res:// and user://
## ---------------------------------

# Temporary Cache: Useful for constantly changing textures but can save time for cache hits
# Sort of like a FIFO cache
const MAX_CACHE_SIZE = 1000
var _temp_cache: Dictionary[String, Texture2D] = {}

# Permenent Cache,useful for consistent data for an entire scene 
var _perm_cache: Dictionary[String, Texture2D] = {}  # optional runtime cache for fast access


# Texture Folders
const confed_folder: String = "res://assets/textures/confed_logo/"
const terr_folder: String = "res://assets/textures/territory_logo/"
const tour_folder: String = "res://assets/textures/tournament_logo/"
const team_folder: String = "res://assets/textures/team_logo/"

# ---------------------------------
# Move an asset from res:// to user:// (e.g., database, save files)
# ---------------------------------
func move_to_user(path_res: String, overwrite := false) -> String:
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
func load_asset(path: String, use_cache := false) -> Texture2D:
	if use_cache and _perm_cache.has(path):
		return _perm_cache[path]
		
	if _temp_cache.has(path):
		return _temp_cache[path]
		
	var file_access: FileAccess = FileAccess.open(path, FileAccess.READ)
	
	if FileAccess.get_open_error() != OK:
		return null

	var buffer: PackedByteArray = file_access.get_buffer(file_access.get_length())
	var image: Image = Image.new()
	var error: Error = image.load_webp_from_buffer(buffer) # Assuming WebP
	
	if error != OK:
		return null

	var texture: ImageTexture = ImageTexture.create_from_image(image)

	if texture:
		if use_cache:
			_perm_cache[path] = texture
			return texture
		
		if _temp_cache.size() >= MAX_CACHE_SIZE:
			var key_to_remove: String = _temp_cache.keys()[0]
			_temp_cache.erase(key_to_remove)
		_temp_cache[path] = texture
			
		return texture
	else:
		push_error("AssetManager: Failed to load %s" % path)
		return null
		
func load_user_asset(path: String) -> void:
	# First, we simply load the image
	var img: Image = Image.load_from_file(path);

	
	
	
	pass

# ---------------------------------
# Save a resource (always to user folder)
# ---------------------------------
func save__user_asset(path: String, image: Image) -> bool:
	# Ensure Path is Valid
	path.replace("res://", "user://")
	if path.length() == 0:
		return false;
	
	
		
	
	
	
	
	
	
	return false;

# ---------------------------------
# Preload commonly used assets on startup
# ---------------------------------
func preload_confed_logos() -> void:
	
	pass
