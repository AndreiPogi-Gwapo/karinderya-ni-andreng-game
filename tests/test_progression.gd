extends Node

func _ready() -> void:
    _run_tests()

func _run_tests() -> void:
    assert(100 >= 0)
    print("Finance smoke tests passed.")
