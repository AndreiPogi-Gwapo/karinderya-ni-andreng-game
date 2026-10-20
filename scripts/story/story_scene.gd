extends Control

@onready var student_name_input: LineEdit = $Panel/Center/HBox/VBox/StudentNameInput
@onready var lrn_input: LineEdit = $Panel/Center/HBox/VBox/LRNInput
@onready var error_label: Label = $Panel/Center/HBox/VBox/ErrorLabel
@onready var profile_dropdown: OptionButton = $Panel/Center/HBox/VBox/ProfileDropdown
@onready var continue_button: Button = $Panel/Center/HBox/VBox/Buttons/ContinueButton
@onready var create_button: Button = $Panel/Center/HBox/VBox/Buttons/CreateButton

func _ready() -> void:
    _load_profiles()

func _load_profiles() -> void:
    profile_dropdown.clear()
    var profiles = SaveManager.load_profiles() if SaveManager.has_method("load_profiles") else []
    if profiles.is_empty():
        profile_dropdown.add_item("No saved profile")
        return
    for profile in profiles:
        profile_dropdown.add_item(str(profile.get("name", "Player")) + " - " + profile.get("lrn", ""))

func _validate_name() -> bool:
    return student_name_input.text.strip_edges().length() > 0

func _validate_lrn() -> bool:
    var regex = RegEx.new()
    regex.compile("^\\d{12}$")
    return regex.search(lrn_input.text.strip_edges()) != null

func _on_create_button_pressed() -> void:
    if not _validate_name():
        error_label.text = "Student name cannot be empty."
        return
    if not _validate_lrn():
        error_label.text = "LRN must be a 12-digit number."
        return
    var lrn := lrn_input.text.strip_edges()
    if SaveManager.has_profile_with_lrn(lrn):
        error_label.text = "This LRN already has a profile."
        return
    var profile := SaveManager.create_or_update_profile(student_name_input.text, lrn)
    SaveManager.current_profile = profile
    GameManager.set_current_profile(profile)
    SaveManager.save_game()
    error_label.text = "Profile created successfully."
    get_tree().change_scene_to_file("res://scenes/story/story_scene.tscn")

func _on_continue_button_pressed() -> void:
    var profiles = SaveManager.load_profiles() if SaveManager.has_method("load_profiles") else []
    if profiles.is_empty():
        error_label.text = "No saved profile found."
        return
    var selected_text := profile_dropdown.get_item_text(profile_dropdown.selected)
    if selected_text == "No saved profile":
        error_label.text = "Create a profile first."
        return
    var selected_lrn := selected_text.split(" - ")[-1]
    for profile in profiles:
        if profile.get("lrn", "") == selected_lrn:
            SaveManager.current_profile = profile
            GameManager.set_current_profile(profile)
            SaveManager.profile_name = str(profile.get("name", "Player"))
            SaveManager.save_game()
            get_tree().change_scene_to_file("res://scenes/story/story_scene.tscn")
            return
    error_label.text = "Unable to resume selected profile."

func _on_back_button_pressed() -> void:
    get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
