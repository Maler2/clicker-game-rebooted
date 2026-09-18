extends Control

signal close_request_audio

@onready var master_slider: HSlider = $panel/vboxcontainer/master/slider
@onready var close_button: Button = $panel/vboxcontainer/close/button
@onready var sfx_slider: HSlider = $panel/vboxcontainer/sfx/slider
@onready var master_label: Label = $panel/vboxcontainer/master/label
@onready var sfx_label: Label = $panel/vboxcontainer/sfx/label

func _ready() -> void:
    Global.preference_loading()
    visible = false
    position.y = -648
    master_slider.value = Global.master_val
    sfx_slider.value = Global.sfx_val
    master_slider.value_changed.connect(master_slider_changed)
    sfx_slider.value_changed.connect(sfx_slider_changed)
    close_button.pressed.connect(close_btn_pressed)
    master_slider.drag_ended.connect(master_slider_drag)
    print(master_slider.value)
    upd_slider()

func upd_slider() -> void:
    master_label.text = ("Master: %d" % master_slider.value)
    sfx_label.text = ("SFX: %d" % sfx_slider.value)


func master_slider_changed(val: float) -> void:
    print(int(val), " master")

    var master_index: int = AudioServer.get_bus_index("Master")

    if master_index != -1:
        var linear_val: float = max(val / 100.0, 0.0001)

        var db_val: float = linear_to_db(linear_val)
        AudioServer.set_bus_volume_db(master_index, db_val)
        Global.master_val = val
    
    upd_slider()

func sfx_slider_changed(val: float) -> void:
    print(int(val), " sfx")

    var sfx_index: int = AudioServer.get_bus_index("sfx")

    if sfx_index != -1:
        var linear_val: float = max(val / 100.0, 0.0001)

        var db_val: float = linear_to_db(linear_val)
        AudioServer.set_bus_volume_db(sfx_index, db_val)
        Global.sfx_val = val
    
    upd_slider()

func master_slider_drag(_value_changed_flag: bool) -> void:
    Global.preference_saving()

func close_btn_pressed() -> void:
    close_request_audio.emit()

