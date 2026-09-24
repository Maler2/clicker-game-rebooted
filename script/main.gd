# root nodenya
extends Control

# variable nodenya
@onready var click_button: Button = $clickbutton
@onready var info_label: Label = $infolabel
@onready var shop: Control = $shop
@onready var shop_button: Button = $shopbutton
@onready var auto_timer: Timer = $autotimer
@onready var menu_button: Button = $menubutton
@onready var menu: Control = $menu
@onready var setting: Control = $setting
@onready var click_sound: AudioStreamPlayer = $clicksound
@onready var audio: Control = $audio
@onready var debug_label: Label = $debuglabel
@onready var other: Control = $other
@onready var bg: TextureRect = $bg
@onready var critical_bar: ProgressBar = $crit_bar

# variablenya
var luck: float = randf_range(0, 1)
var time_played: int = 0
var end_screen: int = 1280
var speed_scroll: int = 50

# saat masuk ke gamenya?
func _ready() -> void:
	# load
	Global.loading()
	print("Main Loaded!")
	Global.preference_loading()
	Global.theme_changed.connect(theme_change)
	bg_color_changed(Global.bg_color)

	theme = Global.get_current_theme()


	# start
	self.scale = Vector2.ZERO

	# tween?
	var tween: Tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 1).set_trans(Tween.TRANS_EXPO)

	# global connect
	Global.update_point.connect(upd_point)

	# cek auto clicker
	auto_timer_call()

	# connect
	click_button.pressed.connect(_click_btn_pressed)
	shop_button.pressed.connect(_shop_btn_pressed)
	shop.close_request.connect(close_shop)
	menu.close_request.connect(close_menu)
	menu_button.pressed.connect(menu_btn_pressed)
	menu.anim_play_quit.connect(play_quit)
	menu.setting_request.connect(open_setting)
	setting.close_request_setting.connect(close_setting)
	setting.anim_play_restart.connect(play_restart)
	shop.auto_timer_on.connect(auto_timer_call)
	setting.audio_request.connect(open_audio)
	audio.close_request_audio.connect(close_audio)
	setting.other_request.connect(open_other)
	other.close_request_other.connect(close_other)
	other.apply.connect(theme_change)
	other.bg_color_request.connect(bg_color_changed)
	critical_bar.changed.connect(crit_bar_changed)

	# text
	shop_button.text = "Shop"

	# pivot (posisi dari node tersebut)
	click_button.pivot_offset = Vector2(64, 64)
	shop_button.pivot_offset = Vector2(64, 64)
	self.pivot_offset = Vector2(640, 360)
	menu_button.pivot_offset.x = 64

	# tween (animasi)
	click_button.mouse_entered.connect(click_btn_entered)
	click_button.mouse_exited.connect(click_btn_exited)
	shop_button.mouse_entered.connect(shop_btn_entered)
	shop_button.mouse_exited.connect(shop_btn_exited)
	menu_button.mouse_entered.connect(menu_btn_entered)
	menu_button.mouse_exited.connect(menu_btn_exited)

	# hide or show
	debug_label.visible = false

	# timer
	auto_timer.timeout.connect(auto_click_time)

	# project setting
	get_window().transparent = true
	
	debug_label_info()

	# silly
	# yes i make this comment to make something dumb or not useful enough
	print(str(Global.point).length())
	upd_point()

# selalu update

func _process(delta: float) -> void:
	debug_label_info()
	if bg.position.x <= 0:
		bg.position.x += speed_scroll * delta
	else:
		bg.position.x -= 640.0

	if bg.position.y <= 0:
		bg.position.y += speed_scroll * delta
	else:
		bg.position.y -= 64.0


	if critical_bar.value >= 0:
		decrease_crit_bar(delta)

func _input(event: InputEvent) -> void:
	var f3_first: bool = event.is_action_pressed("f3_key") and Input.is_action_pressed("d_key")
	var d_first: bool = event.is_action_pressed("d_key") and Input.is_action_pressed("f3_key")
	
	if f3_first or d_first:
		if debug_label.visible:
			debug_label.visible = false
		else:
			debug_label.visible = true

# animasi

func click_btn_entered() -> void:
	node_scale(click_button, 1.2, 1.3, 1.1, 1.1, 5, 1, 0.3)

func click_btn_exited() -> void:
	node_scale(click_button, 0.8, 0.9, 1.0, 1.0, 5, 1, 0.3)

func shop_btn_entered() -> void:
	node_scale(shop_button, 1.25, 1.35, 1.1, 1.1, 5, 1, 0.3)

func shop_btn_exited() -> void:
	node_scale(shop_button, 0.75, 0.85, 1.0, 1.0, 5, 1, 0.3)

func menu_btn_entered() -> void:
	node_scale(menu_button, 0.65, 0.8, 1.1, 1.1, 5, 1, 0.3)

func menu_btn_exited() -> void:
	node_scale(menu_button, 0.65, 0.75, 1.0, 1.0, 5, 1, 0.3)

# buka shop
func open_shop() -> void:
	shop.visible = true
	node_pos(shop, false, false, 264, 0, 5, 1, 0.4)

# tutup shop
func close_shop() -> void:
	node_pos(shop, true, false, 0, 0, 5, 0, 0.4)

# buka menu
func open_menu() -> void:
	menu.visible = true
	node_pos(menu, false, false, 427, 0, 5, 1, 0.4)

# tutup menu
func close_menu() -> void:
	node_pos(menu, true, false, 427, -720, 5, 0, 0.4)

# buka setting
func open_setting() -> void:
	setting.visible = true
	await node_pos(menu, true, false, 427, -720, 5, 0, 0.4)
	node_pos(setting, false, false, 427, 0, 5, 1, 0.4)

# tutup setting
func close_setting() -> void:
	await node_pos(setting, true, false, 427, -720, 5, 0, 0.4)
	menu.visible = true
	node_pos(menu, false, false, 427, 0, 5, 1, 0.4)

func open_audio() -> void:
	audio.visible = true
	await node_pos(setting, true, false, 427, -720, 5, 0, 0.4)
	node_pos(audio, false, false, 427, 0, 5, 1, 0.4)

func close_audio() -> void:
	await node_pos(audio, true, false, 427, -720, 5, 0, 0.4)
	setting.visible = true
	node_pos(setting, false, false, 427, 0, 5, 1, 0.4)

func open_other() -> void:
	other.visible = true
	await node_pos(setting, true, false, 427, -720, 5, 0, 0.4)
	node_pos(other, false, false, 427, 0, 5, 1, 0.4)

func close_other() -> void:
	await node_pos(other, true, false, 427, -720, 5, 0, 0.4)
	setting.visible = true
	node_pos(setting, false, false, 427, 0, 5, 1, 0.4)

# fungsi

func crit_bar_changed() -> void:
	critical_bar.value += Global.add_crit_bar

func decrease_crit_bar(delta: float) -> void:
	critical_bar.value -= Global.speed_crit_bar * delta

func theme_change() -> void:
	theme = Global.get_current_theme()

func auto_timer_call() -> void:
	if Global.auto_timer_point == 0:
		print(auto_timer_call.get_method(), ": false")
		auto_timer.stop()
	else:
		print(auto_timer_call.get_method(), ": true")
		auto_timer.start()

func debug_label_info() -> void:
	debug_label.text = "Debug\nChance: %.2f\nbg_pos: X %.2f Y %.2f\nbg_color: %s\nadd_crit: %d\nspeed_crit %d" % [luck, bg.position.x, bg.position.y, Global.bg_color.to_html(false), Global.add_crit_bar, Global.speed_crit_bar]

# fungsi kustom
func upd_point() -> void:
	info_label.text = "Point: %d | Add: %d | Auto Add: %d | Chance: %.2f | Add Crit: %d" % [Global.point, Global.add_point, Global.auto_timer_point, Global.luck_float, Global.add_crit_bar]
	click_button.text = "+%d" % Global.add_point

# buat auto clicknya
func auto_click_time() -> void:
	click_sound.pitch_scale = randf_range(0.4, 0.5)
	click_sound.play()
	auto_click()

# buat nambah point otomatis
func auto_click() -> void:
	Global.point += Global.auto_timer_point

# shop
func _shop_btn_pressed() -> void:
	if shop.position.x <= 0:
		open_shop()
	else:
		close_shop()

# fungsi tombol

func _click_btn_pressed() -> void:
	if Global.add_point > 0:
		var tween: Tween = create_tween().set_parallel(true)
		luck = randf_range(0, 1)
		click_sound.pitch_scale = randf_range(0.9, 1.1)
		click_sound.play()
		tween.tween_property(click_button, "scale", Vector2(1.05, 1.05), 0.1)
		tween.tween_property(click_button, "modulate", Color(1, 1, 1, 1), 0.1)

		tween.chain().tween_property(click_button, "scale", Vector2(1.1, 1.1), 0.1)
		tween.parallel().tween_property(click_button, "modulate", Color(2, 2, 2, 1), 0.1)
		if luck >= Global.luck_float:
			Global.point += (Global.add_point * 2)
			PopupGlobal.popup("+", Global.add_point * 2)
		else:
			Global.point += Global.add_point
			PopupGlobal.popup("+", Global.add_point)
		
		crit_bar_changed()
		if critical_bar.value >= 100:
			Global.point += (Global.add_point * 5)
			PopupGlobal.popup("+", Global.add_point * 5)
			critical_bar.value -= 100
		debug_label_info()

		upd_point()
	else:
		push_warning("ADD POINT ITS LESS THAN 1! (%d)" % Global.add_point)

# fungsi tombol (menu button)
func menu_btn_pressed() -> void:
	if menu.position.y < 0:
		open_menu()
	else:
		close_menu()

# lain

# memainkan animasi keluar
func play_quit() -> void:
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "scale", Vector2(0, 0), 1).set_trans(Tween.TRANS_EXPO)
	var global_tween = PopupGlobal.create_tween().set_parallel(true)
	global_tween.tween_property(PopupGlobal, "scale", Vector2(0, 0), 1).set_trans(Tween.TRANS_EXPO)

# memainkan restart
func play_restart() -> void:
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(2000, 0), 1).set_trans(Tween.TRANS_EXPO)

func bg_color_changed(color: Color) -> void:
	var shader_mat = bg.material as ShaderMaterial

	if shader_mat:
		shader_mat.set_shader_parameter("bg_color", color)

# helper

## function ini adalah helper yang buat mengescale atau mengubah ukuran dari nodenya [br][b]cara pakai kode ini di functionnya misalnya enter dan exit[/b][br][code]node_scale(nama_node, frekuensi_a, frekuensi_b, ukuran_x, ukuran_y, tipe_transisi, tipe_ease, waktu)[/code][br][b]info parameter[/b][br][param node] target dari nodenya[br][param time_sound_a] pitch pertama atau nilai pertama[br][param time_sound_b] pitch kedua atau nilai kedua[br][param scale_x] ukuran dari nilai x[br][param scale_y] ukuran dari nilai y[br][param type_trans] tipe dari transisi tersebut default 5 (exponent)[br][param type_ease] time dari easenya default 1 (out)[br][param time] waktu dari tween tersebut
func node_scale(node: Node, time_sound_a: float, time_sound_b: float, scale_x: float, scale_y: float, type_trans: int = 5, type_ease: int = 1, time: float = 1.0) -> void:
	var tween: Tween = create_tween()
	click_sound.pitch_scale = randf_range(time_sound_a, time_sound_b)
	click_sound.play()
	tween.tween_property(node, "scale", Vector2(scale_x, scale_y), time).set_trans(type_trans).set_ease(type_ease)

## [b]sebuah helper untuk meminimalisir kodenya[/b][br]untuk transisi: [url=https://docs.godotengine.org/en/stable/classes/class_tween.html#enum-tween-transitiontype]Klik Di Sini[/url][br]untuk ease: [url=https://docs.godotengine.org/en/stable/classes/class_tween.html#enum-tween-easetype]Klik Di Sini[/url][br]
func node_pos(node: Node, is_cmd: bool, type_bool: bool, pos_x: int, pos_y: int, type_trans: int = 5, type_ease: int = 1, time: float = 1.0) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(node, "position", Vector2(pos_x, pos_y), time).set_trans(type_trans).set_ease(type_ease)
	if is_cmd:
		tween.tween_callback(func(): node.visible = type_bool)

	await tween.finished
