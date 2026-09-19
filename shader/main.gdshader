shader_type canvas_item;

// Uniform akan muncul di Inspector Godot sebagai parameter yang bisa di-edit
uniform vec4 bg_color : source_color = vec4(0.12, 0.12, 0.18, 1.0);
uniform float color_intensity : hint_range(0.0, 2.0) = 1.0;

void fragment() {
	// Ambil warna piksel bawaan/tekstur
	vec4 tex_color = texture(TEXTURE, UV);
	
	// Campur warna tekstur dengan bg_color
	COLOR = tex_color * bg_color * color_intensity;
}