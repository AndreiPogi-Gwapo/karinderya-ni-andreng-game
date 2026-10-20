extends Control

@onready var title_label: Label = $Panel/TopBar/TitleLabel
@onready var speaker_label: Label = $Panel/DialogueArea/SpeakerLabel
@onready var text_label: RichTextLabel = $Panel/DialogueArea/DialogueBox/DialogueText
@onready var choice_container: VBoxContainer = $Panel/ChoiceArea/ChoiceContainer
@onready var money_label: Label = $Panel/StatsPanel/Stats/ValueMoney
@onready var points_label: Label = $Panel/StatsPanel/Stats/ValuePoints
@onready var trust_label: Label = $Panel/StatsPanel/Stats/ValueTrust
@onready var timer_label: Label = $Panel/StatsPanel/Stats/ValueTimer

var story_scenes: Array = []
var current_scene: Dictionary = {}
var current_index: int = 0
var timer_seconds: int = 300
var typing_active: bool = false
var choice_buttons: Array = []

func _ready() -> void:
    _load_story()
    _apply_scene(0)
    set_process(true)

func _load_story() -> void:
    var file := FileAccess.open("res://data/story/story_data.json", FileAccess.READ)
    if file == null:
        return
    var json := JSON.new()
    var err := json.parse(file.get_as_text())
    if err != OK:
        return
    var data: Dictionary = json.data
    story_scenes = data.get("scenes", [])
    if story_scenes.is_empty():
        return
    if not GameManager.current_scene.is_empty():
        current_scene = GameManager.current_scene
        current_index = story_scenes.find(current_scene)

func _apply_scene(index: int) -> void:
    if story_scenes.is_empty():
        return
    if index < 0 or index >= story_scenes.size():
        index = story_scenes.size() - 1
    current_index = index
    current_scene = story_scenes[current_index]
    GameManager.current_scene = current_scene
    title_label.text = str(current_scene.get("title", "Day"))
    speaker_label.text = str(current_scene.get("speaker", "Narrator"))
    text_label.text = str(current_scene.get("text", ""))
    _populate_choices(current_scene.get("choices", []))
    _refresh_stats()

func _populate_choices(choices: Array) -> void:
    for child in choice_container.get_children():
        child.queue_free()
    choice_buttons.clear()
    if choices.is_empty():
        var next_button := Button.new()
        next_button.text = "Continue"
        next_button.pressed.connect(_on_continue_pressed)
        choice_container.add_child(next_button)
        choice_buttons.append(next_button)
        return
    for i in range(choices.size()):
        var choice = choices[i]
        var button := Button.new()
        button.text = str(i + 1) + ". " + str(choice.get("text", "Choice"))
        button.pressed.connect(_on_choice_selected.bind(choice))
        choice_container.add_child(button)
        choice_buttons.append(button)

func _on_choice_selected(choice: Dictionary) -> void:
    if choice.is_empty():
        return
    GameManager.apply_choice(choice)
    var next_scene_id = str(choice.get("next", ""))
    var next_scene_index := -1
    for i in range(story_scenes.size()):
        if str(story_scenes[i].get("id", "")) == next_scene_id:
            next_scene_index = i
            break
    if next_scene_index >= 0:
        _apply_scene(next_scene_index)
    else:
        print("End of story reached.")

func _on_continue_pressed() -> void:
    if current_index < story_scenes.size() - 1:
        _apply_scene(current_index + 1)

func _refresh_stats() -> void:
    money_label.text = str(SaveManager.money)
    points_label.text = str(SaveManager.total_points)
    trust_label.text = str(SaveManager.friendship_trust)
    timer_label.text = str(timer_seconds)

func _process(delta: float) -> void:
    if timer_seconds > 0:
        timer_seconds -= int(delta)
        if timer_seconds < 0:
            timer_seconds = 0
        timer_label.text = str(timer_seconds)
        if timer_seconds == 0:
            _on_continue_pressed()

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventKey and event.pressed:
        if event.keycode == KEY_SPACE or event.keycode == KEY_ENTER:
            _on_continue_pressed()
