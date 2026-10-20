extends Node

const SAVE_PATH := "user://karinderya_profiles.json"

var profiles: Array = []
var current_profile: Dictionary = {}

func _ready() -> void:
    profiles = load_profiles()

func load_profiles() -> Array:
    if not FileAccess.file_exists(SAVE_PATH):
        return []
    var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
    if file == null:
        return []
    var data = JSON.parse_string(file.get_as_text())
    if typeof(data) == TYPE_DICTIONARY and data.has("profiles"):
        return data["profiles"]
    return []

func save_profiles() -> bool:
    var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
    if file == null:
        return false
    var data := {"profiles": profiles}
    file.store_string(JSON.stringify(data, "\t"))
    return true

func save_game() -> bool:
    var payload := {
        "current_profile": current_profile,
        "profiles": profiles,
        "game_data": GameManager.get_save_data()
    }
    var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
    if file == null:
        return false
    file.store_string(JSON.stringify(payload, "\t"))
    return true

func load_game() -> Dictionary:
    if not FileAccess.file_exists(SAVE_PATH):
        return {}
    var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
    if file == null:
        return {}
    var text := file.get_as_text()
    var json := JSON.new()
    var error := json.parse(text)
    if error != OK:
        return {}
    var data = json.data
    if typeof(data) != TYPE_DICTIONARY:
        return {}
    return data

func apply_loaded_game(data: Dictionary) -> void:
    if data.is_empty():
        return
    if data.has("profiles"):
        profiles = data["profiles"]
    if data.has("current_profile"):
        current_profile = data["current_profile"]
    if data.has("game_data"):
        GameManager.apply_save_data(data["game_data"])

func create_or_update_profile(student_name: String, lrn: String) -> Dictionary:
    var normalized_name: String = student_name.strip_edges()
    var normalized_lrn: String = lrn.strip_edges()
    var existing_idx := -1
    for i in range(profiles.size()):
        if profiles[i].get("lrn", "") == normalized_lrn:
            existing_idx = i
            break
    if existing_idx >= 0:
        profiles[existing_idx]["name"] = normalized_name
        profiles[existing_idx]["updated_at"] = Time.get_datetime_string_from_system()
        current_profile = profiles[existing_idx]
        return current_profile
    var profile := {
        "id": str(Time.get_unix_time_from_system()),
        "name": normalized_name,
        "lrn": normalized_lrn,
        "created_at": Time.get_datetime_string_from_system(),
        "updated_at": Time.get_datetime_string_from_system(),
        "money": 0,
        "total_points": 0,
        "achievements": [],
        "keys": 0,
        "points_spent": 0,
        "playtime": 0,
        "unlocked_endings": []
    }
    profiles.append(profile)
    current_profile = profile
    return current_profile

func get_last_profile() -> Dictionary:
    if profiles.is_empty():
        return {}
    return profiles[-1]

func has_profile_with_lrn(lrn: String) -> bool:
    for profile in profiles:
        if profile.get("lrn", "") == lrn:
            return true
    return false
