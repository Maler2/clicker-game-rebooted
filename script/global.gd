extends Node

const save_path: String = "user://savefile.json"

signal update_point


var point: int = 0:
	set(val):
		point = val
		update_point.emit()

var add_point: int = 1:
	set(val):
		add_point = val
		update_point.emit()

var add_point_cost: int = 10:
	set(val):
		add_point_cost = val
		update_point.emit()

var auto_timer_point: int = 0:
	set(val):
		auto_timer_point = val
		update_point.emit()

var auto_timer_point_cost: int = 100:
	set(val):
		auto_timer_point_cost = val
		update_point.emit()

func _ready() -> void:
	var auto_save_timer: Timer = Timer.new()
	auto_save_timer.wait_time = 60.0
	auto_save_timer.autostart = true
	auto_save_timer.timeout.connect(saving)
	add_child(auto_save_timer)

func saving() -> void:
	var data: Dictionary = {
		"point": point,
		"add_point": add_point,
		"add_point_cost": add_point_cost,
		"auto_timer_point": auto_timer_point,
		"auto_timer_point_cost": auto_timer_point_cost
	}

	var json_string: String = JSON.stringify(data)

	var file: FileAccess = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		file.store_line(json_string)
		file.close()
		print("\nSaved!")

func loading() -> void:
	if !FileAccess.file_exists(save_path):
		return

	var file: FileAccess = FileAccess.open(save_path, FileAccess.READ)
	if file:
		var json_string: String = file.get_line()
		file.close()

		var data: Variant = JSON.parse_string(json_string)

		if data is Dictionary:
			point = data.get("point", point)
			add_point = data.get("add_point", add_point)
			add_point_cost = data.get("add_point_cost", add_point_cost)
			auto_timer_point = data.get("auto_timer_point", auto_timer_point)
			auto_timer_point_cost = data.get("auto_timer_point_cost", auto_timer_point_cost)
			print("Loaded!")

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		saving()

func reset_data() -> void:
	if FileAccess.file_exists(save_path):
		DirAccess.remove_absolute(save_path)

	OS.set_restart_on_exit(true)
	get_tree().quit()
