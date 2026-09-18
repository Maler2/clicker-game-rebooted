# root nodenya
extends Control

# nodenya
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

# variablenya
var luck: float = randf_range(0, 1)
var time_played: int = 0

# saat masuk ke gamenya?
func _ready() -> void:
	# load
	Global.loading()
	print("Main Loaded!")
	Global.preference_loading()
	

	# start
	self.scale = Vector2.ZERO

	# tween?
	var tween: Tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 1).set_trans(Tween.TRANS_EXPO)

	# global connect
	Global.update_point.connect(upd_point)

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

	# text
	shop_button.text = "Shop"

	# pivot (posisi dari node tersebut)
	click_button.pivot_offset = Vector2(64, 64)
	shop_button.pivot_offset = Vector2(64, 64)
	self.pivot_offset = Vector2(576, 324)
	menu_button.pivot_offset.x = 64

	# tween (animasi)
	click_button.mouse_entered.connect(click_btn_entered)
	click_button.mouse_exited.connect(click_btn_exited)
	shop_button.mouse_entered.connect(shop_btn_entered)
	shop_button.mouse_exited.connect(shop_btn_exited)
	menu_button.mouse_entered.connect(menu_btn_entered)
	menu_button.mouse_exited.connect(menu_btn_exited)

	# timer
	auto_timer.timeout.connect(auto_click_time)

	# project setting
	get_window().transparent = true
	
	debug_label_info()

	# silly
	# yes i make this comment to make something dumb or not useful enough
	pass
	upd_point()

func auto_timer_call() -> void:
	if Global.auto_timer_point == 0:
		print(auto_timer_call.get_method(), ": false")
		auto_timer.stop()
	else:
		print(auto_timer_call.get_method(), ": true")
		auto_timer.start()

func debug_label_info() -> void:
	debug_label.text = "Chance: %.2f" % luck

# fungsi kustom
func upd_point() -> void:
	info_label.text = "Point: %d | Add: %d | Auto Add %d | Chance %.2f" % [Global.point, Global.add_point, Global.auto_timer_point, Global.luck_float]
	click_button.text = "+%d" % Global.add_point

# fungsi tombol (click button)
func _click_btn_pressed() -> void:
	var tween: Tween = create_tween()
	luck = randf_range(0, 1)
	click_sound.pitch_scale = randf_range(0.9, 1.1)
	click_sound.play()
	tween.tween_property(click_button, "scale", Vector2(1.05, 1.05), 0.1)
	tween.tween_property(click_button, "scale", Vector2(1.1, 1.1), 0.1)
	if luck >= Global.luck_float:
		Global.point += (Global.add_point * 2)
		PopupGlobal.popup("+", (Global.add_point * 2))
	else:
		Global.point += Global.add_point
		PopupGlobal.popup("+", Global.add_point)
	debug_label_info()
	
	upd_point()

# animasi
func click_btn_entered() -> void:
	var tween: Tween = create_tween()
	click_sound.pitch_scale = randf_range(1.2, 1.3)
	click_sound.play()
	tween.tween_property(click_button, "scale", Vector2(1.1, 1.1), 0.3).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)

func click_btn_exited() -> void:
	var tween: Tween = create_tween()
	click_sound.pitch_scale = randf_range(0.8, 0.9)
	click_sound.play()
	tween.tween_property(click_button, "scale", Vector2(1.0, 1.0), 0.3).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)

func shop_btn_entered() -> void:
	var tween: Tween = create_tween()
	click_sound.pitch_scale = randf_range(1.25, 1.35)
	click_sound.play()
	tween.tween_property(shop_button, "scale", Vector2(1.1, 1.1), 0.3).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)

func shop_btn_exited() -> void:
	var tween: Tween = create_tween()
	click_sound.pitch_scale = randf_range(0.75, 0.85)
	click_sound.play()
	tween.tween_property(shop_button, "scale", Vector2(1.0, 1.0), 0.3).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)

func menu_btn_entered() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(menu_button, "scale", Vector2(1.1, 1.1), 0.3).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)

func menu_btn_exited() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(menu_button, "scale", Vector2(1.0, 1.0), 0.3).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)

# buat loop
func auto_click_time() -> void:
	click_sound.pitch_scale = randf_range(0.4, 0.5)
	click_sound.play()
	auto_click()

# buat nambah point otomatis
func auto_click() -> void:
	Global.point += Global.auto_timer_point

# fungsi tombol (shop button)
func _shop_btn_pressed() -> void:
	if shop.position.x <= 0:
		open_shop()
	else:
		close_shop()

# fungsi tombol (menu button)
func menu_btn_pressed() -> void:
	if menu.position.y < 0:
		open_menu()
	else:
		close_menu()

# buka shop
func open_shop() -> void:
	var tween := create_tween()
	shop.visible = true
	tween.tween_property(shop, "position", Vector2(256, 0), 0.4).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)

# tutup shop
func close_shop() -> void:
	var tween := create_tween()
	tween.tween_property(shop, "position", Vector2(0, 0), 0.4).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	tween.tween_callback(func(): shop.visible = false)

# buka menu
func open_menu() -> void:
	var tween := create_tween()
	menu.visible = true
	tween.tween_property(menu, "position", Vector2(384, 0), 0.4).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)

# tutup menu
func close_menu() -> void:
	var tween := create_tween()
	tween.tween_property(menu, "position", Vector2(384, -648), 0.4).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	tween.tween_callback(func(): menu.visible = false)

# memainkan animasi keluar
func play_quit() -> void:
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "scale", Vector2(0, 0), 1).set_trans(Tween.TRANS_EXPO)
	var global_tween = PopupGlobal.create_tween().set_parallel(true)
	global_tween.tween_property(PopupGlobal, "scale", Vector2(0, 0), 1).set_trans(Tween.TRANS_EXPO)

# buka setting
func open_setting() -> void:
	var tween: Tween = create_tween()
	setting.visible = true
	tween.tween_property(menu, "position", Vector2(384, -648), 0.4).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	tween.tween_callback(func(): menu.visible = false)
	tween.tween_property(setting, "position", Vector2(384, 0), 0.4).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)

# tutup setting
func close_setting() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(setting, "position", Vector2(384, -648), 0.4).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	tween.tween_callback(func(): setting.visible = false)
	menu.visible = true
	tween.tween_property(menu, "position", Vector2(384, 0), 0.4).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)

# memainkan restart
func play_restart() -> void:
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(2000, 0), 1).set_trans(Tween.TRANS_EXPO)

func open_audio() -> void:
	var tween: Tween = create_tween()
	audio.visible = true
	tween.tween_property(setting, "position", Vector2(384, -648), 0.4).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	tween.tween_callback(func(): setting.visible = false)
	tween.tween_property(audio, "position", Vector2(384, 0), 0.4).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)

func close_audio() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(audio, "position", Vector2(384, -648), 0.4).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	tween.tween_callback(func(): audio.visible = false)
	setting.visible = true
	tween.tween_property(setting, "position", Vector2(384, 0), 0.4).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
