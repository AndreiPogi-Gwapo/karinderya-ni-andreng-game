extends Control

@onready var play_button: Button = $Panel/HBox/RightPanel/Buttons/PlayButton
@onready var sign_in_button: Button = $Panel/HBox/RightPanel/Buttons/SignInButton
@onready var achievements_button: Button = $Panel/HBox/RightPanel/Buttons/AchievementsButton
@onready var leaderboard_button: Button = $Panel/HBox/RightPanel/Buttons/LeaderboardButton
@onready var settings_button: Button = $Panel/HBox/RightPanel/Buttons/SettingsButton
@onready var exit_button: Button = $Panel/HBox/RightPanel/Buttons/ExitButton

func _ready() -> void:
    _refresh_play_state()

func _refresh_play_state() -> void:
    var has_profile: bool = not SaveManager.current_profile.is_empty() or not SaveManager.profile_name.is_empty()
    play_button.disabled = not has_profile

func _on_sign_in_button_pressed() -> void:
    get_tree().change_scene_to_file("res://scenes/menus/sign_in.tscn")

func _on_play_button_pressed() -> void:
    if SaveManager.current_profile.is_empty() and SaveManager.profile_name.is_empty():
        get_tree().change_scene_to_file("res://scenes/menus/sign_in.tscn")
        return
    get_tree().change_scene_to_file("res://scenes/story/story_scene.tscn")

func _on_achievements_button_pressed() -> void:
    print("Achievements opened")

func _on_leaderboard_button_pressed() -> void:
    print("Leaderboard opened")

func _on_settings_button_pressed() -> void:
    print("Settings opened")

func _on_exit_button_pressed() -> void:
    get_tree().quit()
