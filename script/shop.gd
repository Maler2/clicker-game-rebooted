extends Control

# sinyal
signal close_request
signal auto_timer_on

# node
@onready var panel: Panel = $panel
@onready var close_button: Button = $panel/scrollcontainer/vboxcontainer/close/button
@onready var add_point_label: Label = $panel/scrollcontainer/vboxcontainer/addpoint/idlabel
@onready var add_point_button: Button = $panel/scrollcontainer/vboxcontainer/addpoint/button
@onready var auto_label: Label = $panel/scrollcontainer/vboxcontainer/auto/idlabel
@onready var auto_button: Button = $panel/scrollcontainer/vboxcontainer/auto/button
@onready var luck_label: Label = $panel/scrollcontainer/vboxcontainer/luck/idlabel
@onready var luck_button: Button = $panel/scrollcontainer/vboxcontainer/luck/button
@onready var add_crit_label: Label = $panel/scrollcontainer/vboxcontainer/addcrit/idlabel
@onready var add_crit_button: Button = $panel/scrollcontainer/vboxcontainer/addcrit/button

# mulai
func _ready() -> void:
	visible = false
	print("Shop Loaded!")
	Global.loading()
	upd_point()
	add_point_button.pressed.connect(_add_point_btn_pressed)
	auto_button.pressed.connect(auto_button_pressed)
	panel.position.x = -256
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	close_button.pressed.connect(_close_btn_pressed)
	luck_button.pressed.connect(luck_btn)
	add_crit_button.pressed.connect(add_crit_btn)

# alternatif dari main.gd
func upd_point() -> void:
	add_point_label.text = "Add point: %d" % Global.add_point_cost
	auto_label.text = "Auto Clicker: %d" % Global.auto_timer_point_cost
	luck_label.text = "Critical: %d" % Global.luck_cost
	add_crit_label.text = "Add Crit (more faster speed): %d" % Global.add_crit_bar_cost

# tutup pakai tombol
func _close_btn_pressed() -> void:
	close_request.emit()

# fungsi beli
func _add_point_btn_pressed() -> void:
	if Global.point >= Global.add_point_cost:
		Global.point -= Global.add_point_cost
		Global.add_point += 1
		@warning_ignore("narrowing_conversion")
		Global.add_point_cost *= 1.1
		upd_point()
		PopupGlobal.popup("BUYED!")
	else:
		PopupGlobal.popup("NOT ENOUGH POINT!")

func auto_button_pressed() -> void:
	if Global.point >= Global.auto_timer_point_cost:
		Global.point -= Global.auto_timer_point_cost
		Global.auto_timer_point += 1
		auto_timer_on.emit()
		@warning_ignore("narrowing_conversion")
		Global.auto_timer_point_cost *= 1.1
		
		upd_point()
		PopupGlobal.popup("BUYED!")
	else:
		PopupGlobal.popup("NOT ENOUGH POINT!")

func luck_btn() -> void:
	if Global.point >= Global.luck_cost:
		if Global.luck_float <= Global.luck_float_max:
			luck_label.text = "Critical: MAXED"
			PopupGlobal.popup("MAXED!")
		else:
			Global.point -= Global.luck_cost
			Global.luck_float -= 0.05
			@warning_ignore("narrowing_conversion")
			Global.luck_cost *= 1.1
			PopupGlobal.popup("BUYED!")

			upd_point()
	else:
		PopupGlobal.popup("NOT ENOUGH POINT!")

func add_crit_btn() -> void:
	if Global.point >= Global.add_crit_bar_cost:
		if Global.add_crit_bar >= Global.add_crit_bar_max:
			add_crit_label.text = "Add Crit (more faster speed): MAXED"
			PopupGlobal.popup("MAXED!")
		else:
			Global.point -= Global.add_crit_bar_cost
			Global.add_crit_bar += 5
			Global.speed_crit_bar += 3
			@warning_ignore("narrowing_conversion")
			Global. add_crit_bar_cost *= 1.1
			PopupGlobal.popup("BUYED!")
			upd_point()
	else:
		PopupGlobal.popup("NOT ENOUGH POINT!")
