extends Node

var story_data: Dictionary = {}
var current_scene: Dictionary = {}
var current_scene_index: int = 0
var profile_name: String = ""
var current_profile: Dictionary = {}
var day_timer_seconds: int = 300
var day_timer_active: bool = true
var last_valid_scene_id: String = "day_1"

func _ready() -> void:
    _load_story_data()

func _load_story_data() -> void:
    var file := FileAccess.open("res://data/story/story_data.json", FileAccess.READ)
    if file == null:
        push_warning("Story data not found.")
        return
    var json := JSON.new()
    var err := json.parse(file.get_as_text())
    if err != OK:
        push_warning("Story JSON is invalid.")
        return
    story_data = json.data
    if story_data.has("scenes"):
        current_scene = story_data["scenes"][0]
        current_scene_index = 0

func get_scene_by_id(scene_id: String) -> Dictionary:
    if not story_data.has("scenes"):
        return {}
    for scene in story_data["scenes"]:
        if str(scene.get("id", "")) == scene_id:
            return scene
    return {}

func get_save_data() -> Dictionary:
    return {
        "profile_name": profile_name,
        "current_profile": current_profile,
        "current_scene_id": current_scene.get("id", "day_1"),
        "current_day": current_scene_index + 1,
        "money": SaveManager.money,
        "friendship_trust": SaveManager.friendship_trust,
        "business_reputation": SaveManager.business_reputation,
        "entrepreneurship_knowledge": SaveManager.entrepreneurship_knowledge,
        "responsibility": SaveManager.responsibility,
        "total_points": SaveManager.total_points,
        "points_spent": SaveManager.points_spent,
        "keys": SaveManager.keys,
        "achievements": SaveManager.achievements,
        "unlocked_endings": SaveManager.unlocked_endings,
        "playtime_seconds": SaveManager.playtime_seconds,
        "inventory": SaveManager.inventory,
        "current_story_state": SaveManager.current_story_state
    }

func apply_save_data(data: Dictionary) -> void:
    if data.is_empty():
        return
    profile_name = str(data.get("profile_name", profile_name))
    current_profile = data.get("current_profile", current_profile)
    var saved_scene_id := str(data.get("current_scene_id", "day_1"))
    current_scene = get_scene_by_id(saved_scene_id)
    if current_scene.is_empty():
        current_scene = story_data.get("scenes", [])[0]
    current_scene_id = current_scene.get("id", "day_1")
    SaveManager.apply_save_data(data)

func set_profile_name(name: String) -> void:
    profile_name = name

func choose_scene(scene_id: String) -> void:
    var next_scene = get_scene_by_id(scene_id)
    if not next_scene.is_empty():
        current_scene = next_scene
        last_valid_scene_id = scene_id

func apply_choice(choice: Dictionary) -> void:
    if choice.is_empty():
        return
    SaveManager.add_points(int(choice.get("points", 0)))
    SaveManager.add_money(int(choice.get("money", 0)))
    SaveManager.friendship_trust += int(choice.get("trust", 0))
    SaveManager.business_reputation += int(choice.get("reputation", 0))
    SaveManager.entrepreneurship_knowledge += int(choice.get("knowledge", 0))
    SaveManager.responsibility += int(choice.get("responsibility", 0))
    if choice.has("next"):
        choose_scene(str(choice["next"]))

func create_profile_data(student_name: String, lrn: String) -> Dictionary:
    return {
        "name": student_name,
        "lrn": lrn,
        "money": 0,
        "total_points": 0,
        "playtime": 0,
        "keys": 0,
        "achievements": [],
        "unlocked_endings": []
    }

func set_current_profile(profile: Dictionary) -> void:
    current_profile = profile
    SaveManager.current_profile = profile
    if profile.has("name"):
        profile_name = str(profile["name"])
        SaveManager.profile_name = profile_name

func get_profile_display_name() -> String:
    return profile_name if profile_name != "" else "Player"
