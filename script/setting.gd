extends Control

signal close_request_setting
signal anim_play_restart

@onready var back_button: Button = $panel/vboxcontainer/close/button
@onready var reset_button: Button = $panel/vboxcontainer/reset/button

func _ready() -> void:
    visible = false
    position.y = -648
    back_button.pressed.connect(back_btn_pressed)
    reset_button.pressed.connect(reset_btn_pressed)

func back_btn_pressed() -> void:
    close_request_setting.emit()

func reset_btn_pressed() -> void:
    get_window().borderless = true # failsafe
    anim_play_restart.emit()
    await get_tree().create_timer(1).timeout
    Global.reset_data()