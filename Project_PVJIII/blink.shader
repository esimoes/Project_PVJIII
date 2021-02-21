shader_type canvas_item;

render_mode blend_mix;

uniform bool blink = false;


void fragment() {
	vec4 currentColor = texture(TEXTURE, UV);
	
	if (blink)
		currentColor = vec4(abs(sin(TIME*5.0)),0.0,0.0,1.0); //Pero Godot incluye el built-in TIME
		
	COLOR = currentColor;
}

