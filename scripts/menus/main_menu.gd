extends Node

var achievements: Array = []

func _ready() -> void:
    load_achievements()

func load_achievements() -> void:
    var file := FileAccess.open("res://data/achievements/achievements.json", FileAccess.READ)
    if file == null:
        return
    var json := JSON.new()
    var error := json.parse(file.get_as_text())
    if error != OK:
        return
    achievements = json.data

func unlock(id: String) -> void:
    if not SaveManager.achievements.has(id):
        SaveManager.achievements.append(id)
        SaveManager.save_game()

func has_unlocked(id: String) -> bool:
    return SaveManager.achievements.has(id)

func get_achievement_by_id(id: String) -> Dictionary:
    for ach in achievements:
        if ach.get("id", "") == id:
            return ach
    return {}

func get_unlocked_count() -> int:
    return SaveManager.achievements.size()
