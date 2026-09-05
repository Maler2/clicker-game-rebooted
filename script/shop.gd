extends Control

# sinyal
signal close_request

# node
@onready var panel: Panel = $panel
@onready var close_button: Button = $panel/scrollcontainer/vboxcontainer/close/button
@onready var add_point_label: Label = $panel/scrollcontainer/vboxcontainer/addpoint/idlabel
@onready var add_point_button: Button = $panel/scrollcontainer/vboxcontainer/addpoint/button
@onready var auto_label: Label = $panel/scrollcontainer/vboxcontainer/auto/idlabel
@onready var auto_button: Button = $panel/scrollcontainer/vboxcontainer/auto/button

# mulai
func _ready() -> void:
	visible = false
	upd_point()
	add_point_button.pressed.connect(_add_point_btn_pressed)
	auto_button.pressed.connect(auto_button_pressed)
	panel.position.x = -256
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	close_button.pressed.connect(_close_btn_pressed)

# alternatif dari main.gd
func upd_point() -> void:
	add_point_label.text = "Add point: %d" % Global.add_point_cost
	auto_label.text = "Auto Clicker: %d" % Global.auto_timer_point_cost

# tutup pakai tombol
func _close_btn_pressed() -> void:
	close_request.emit()

# fungsi beli
func _add_point_btn_pressed() -> void:
	if Global.point >= Global.add_point_cost:
		Global.point -= Global.add_point_cost
		Global.add_point += 1
		@warning_ignore("narrowing_conversion")
		Global.add_point_cost *= 1.5
		upd_point()

func auto_button_pressed() -> void:
	if Global.point >= Global.auto_timer_point_cost:
		Global.point -= Global.auto_timer_point_cost
		Global.auto_timer_point += 1
		@warning_ignore("narrowing_conversion")
		Global.auto_timer_point_cost *= 1.5
		upd_point()
