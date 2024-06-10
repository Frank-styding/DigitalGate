shader_type canvas_item;
//render_mode blend_disabled;

//uniform sampler2D SCREEN_TEXTURE: hint_screen_texture;
uniform vec3 color;
void vertex() {
    
}

void fragment() {
	COLOR = vec4(color,0.3);
	
	if (UV.y < 0.02 || UV.y > 1.0 - 0.02) {
        COLOR = vec4(color,1);
    }
	
	if (UV.x < 0.02 || UV.x > 1.0 - 0.02) {
        COLOR = vec4(color,1);
    }
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
