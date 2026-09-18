extends Node

const save_path: String = "user://savefile.json"
const preference_path: String = "user://preference.json"

signal update_point

var point: int = 0:
	set(val):
		point = val
		update_point.emit()

var add_point: int = 1:
	set(val):
		add_point = val
		update_point.emit()

var add_point_cost: int = 20:
	set(val):
		add_point_cost = val
		update_point.emit()

var auto_timer_point: int = 0:
	set(val):
		auto_timer_point = val
		update_point.emit()

var auto_timer_point_cost: int = 75:
	set(val):
		auto_timer_point_cost = val
		update_point.emit()

var luck_cost: int = 100:
	set(val):
		luck_cost = val
		update_point.emit()

var luck_float: float = 0.85
var luck_float_max: float = 0.5

func _ready() -> void:
	var auto_save_timer: Timer = Timer.new()
	auto_save_timer.wait_time = 60.0
	auto_save_timer.autostart = true
	auto_save_timer.timeout.connect(saving)
	add_child(auto_save_timer)

var master_val: float = 100.0
var sfx_val: float = 100.0

func saving() -> void:
	var data: Dictionary = {
		"point": point,
		"add_point": add_point,
		"add_point_cost": add_point_cost,
		"auto_timer_point": auto_timer_point,
		"auto_timer_point_cost": auto_timer_point_cost,
		"luck_cost": luck_cost,
		"luck_float": luck_float
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
			luck_cost = data.get("luck_cost", luck_cost)
			luck_float = data.get("luck_float", luck_float)
			print("Loaded!")

func preference_saving() -> void:
	var data: Dictionary = {
		"master_val": master_val,
		"sfx_val": sfx_val
	}

	var json_string: String = JSON.stringify(data)
	var file: FileAccess = FileAccess.open(preference_path, FileAccess.WRITE)
	if file:
		file.store_line(json_string)
		file.close()
		print("\nPREFERENCE SAVED!")

func preference_loading() -> void:
	if !FileAccess.file_exists(preference_path):
		return

	var file: FileAccess = FileAccess.open(preference_path, FileAccess.READ)
	if file:
		var json_string: String = file.get_as_text()
		file.close()

		var data: Variant = JSON.parse_string(json_string)

		if data is Dictionary:
			master_val = data.get("master_val", master_val)
			sfx_val = data.get("sfx_val", sfx_val)
			
			var master_index: int = AudioServer.get_bus_index("Master")
			if master_index != -1:
				var linear_val: float = max(master_val / 100.0, 0.0001)
				AudioServer.set_bus_volume_db(master_index, linear_to_db(linear_val))

			var sfx_index: int = AudioServer.get_bus_index("sfx")
			if sfx_index != -1:
				var linear_val: float = max(sfx_val / 100.0, 0.0001)
				AudioServer.set_bus_volume_db(sfx_index, linear_to_db(linear_val))
				
			print("PREFERENCE LOADED!")

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		saving()

func reset_data() -> void:
	if FileAccess.file_exists(save_path):
		DirAccess.remove_absolute(save_path)

	OS.set_restart_on_exit(true)
	get_tree().quit()
