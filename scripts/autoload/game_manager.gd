extends Node

var profile_name: String = ""
var current_profile: Dictionary = {}
var current_day: int = 1
var current_scene_id: String = "day_1"
var money: int = 0
var friendship_trust: int = 0
var business_reputation: int = 0
var entrepreneurship_knowledge: int = 0
var responsibility: int = 0
var total_points: int = 0
var points_spent: int = 0
var keys: int = 0
var achievements: Array = []
var unlocked_endings: Array = []
var playtime_seconds: int = 0
var inventory: Dictionary = {"rice": 10, "egg": 10, "pancit": 5, "vegetables": 8, "drinks": 8}
var current_story_state: Dictionary = {}

func reset_for_new_game() -> void:
    current_day = 1
    current_scene_id = "day_1"
    money = 0
    friendship_trust = 0
    business_reputation = 0
    entrepreneurship_knowledge = 0
    responsibility = 0
    total_points = 0
    points_spent = 0
    keys = 0
    achievements = []
    unlocked_endings = []
    playtime_seconds = 0
    inventory = {"rice": 10, "egg": 10, "pancit": 5, "vegetables": 8, "drinks": 8}
    current_story_state = {}

func get_save_data() -> Dictionary:
    return {
        "profile_name": profile_name,
        "current_profile": current_profile,
        "current_day": current_day,
        "current_scene_id": current_scene_id,
        "money": money,
        "friendship_trust": friendship_trust,
        "business_reputation": business_reputation,
        "entrepreneurship_knowledge": entrepreneurship_knowledge,
        "responsibility": responsibility,
        "total_points": total_points,
        "points_spent": points_spent,
        "keys": keys,
        "achievements": achievements,
        "unlocked_endings": unlocked_endings,
        "playtime_seconds": playtime_seconds,
        "inventory": inventory,
        "current_story_state": current_story_state
    }

func apply_save_data(data: Dictionary) -> void:
    if data.is_empty():
        return
    profile_name = data.get("profile_name", profile_name)
    current_profile = data.get("current_profile", current_profile)
    current_day = int(data.get("current_day", current_day))
    current_scene_id = str(data.get("current_scene_id", current_scene_id))
    money = int(data.get("money", money))
    friendship_trust = int(data.get("friendship_trust", friendship_trust))
    business_reputation = int(data.get("business_reputation", business_reputation))
    entrepreneurship_knowledge = int(data.get("entrepreneurship_knowledge", entrepreneurship_knowledge))
    responsibility = int(data.get("responsibility", responsibility))
    total_points = int(data.get("total_points", total_points))
    points_spent = int(data.get("points_spent", points_spent))
    keys = int(data.get("keys", keys))
    achievements = data.get("achievements", achievements)
    unlocked_endings = data.get("unlocked_endings", unlocked_endings)
    playtime_seconds = int(data.get("playtime_seconds", playtime_seconds))
    inventory = data.get("inventory", inventory)
    current_story_state = data.get("current_story_state", current_story_state)

func add_points(value: int) -> void:
    total_points = max(0, total_points + value)

func add_money(value: int) -> void:
    money += value

func award_achievement(id: String) -> void:
    if not achievements.has(id):
        achievements.append(id)

func can_unlock_secret() -> bool:
    var config := ConfigFile.new()
    if config.load("res://data/config/game_config.json") != OK:
        return false
    var total_required := int(config.get_value("keys_needed_for_secret", 3))
    return keys >= total_required

func get_masked_lrn(lrn: String) -> String:
    if lrn.length() <= 4:
        return "***"
    return "********" + lrn.substr(lrn.length() - 4, 4)

func get_leaderboard_row() -> Dictionary:
    return {
        "display_name": profile_name,
        "total_points": total_points,
        "playtime": playtime_seconds,
        "achievements": achievements.size()
    }
