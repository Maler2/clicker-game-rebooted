extends Control

@onready var text_label: RichTextLabel = $Textlabel


func _ready() -> void:
	
	text_label.visible = false
	text_label.text = ""

func popup(text: String = "", variable: Variant = null):
	var text_label_clone: RichTextLabel = text_label.duplicate() as RichTextLabel
	add_child(text_label_clone)

	var tween: Tween = create_tween()
	text_label_clone.visible = true
	tween.tween_property(text_label_clone, "position", Vector2(0, 0), 0.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(text_label_clone, "modulate", Color(1, 1, 1, 1), 0.0)
	if variable != null:
		text_label_clone.text = text + str(variable)
	else:
		text_label_clone.text = text

	tween.tween_property(text_label_clone, "position", Vector2(0, -50), 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(text_label_clone, "modulate", Color(1, 1, 1, 0), 0.5)
	await tween.finished
	text_label_clone.queue_free()
