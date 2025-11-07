extends Node

var db: SQLite = SQLite.new()

func init_db(path: String) -> bool:
	db.path = path
	db.foreign_keys = true
	return db.open_db()

func close_db() -> void:
	if db:
		db.close_db()
		db = null

func query_rows(sql: String, params: Array = []) -> Array:
	if not db:
		push_error("DBManager: No database initialized")
		return []

	var success = db.query_with_bindings(sql, params) if params.size() > 0 else db.query(sql)
	if not success:
		push_error("DBManager: Query failed – " + db.error_message)
		return []

	return db.query_result
