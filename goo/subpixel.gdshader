shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float PIXEL_SIZE = 3.;

void fragment() {
	
	vec2 screen_size = 1. / SCREEN_PIXEL_SIZE;
	
	int x = int(UV.x * screen_size.x / PIXEL_SIZE);
	int y = int(UV.y * screen_size.y / PIXEL_SIZE);
	
	vec4 sample = texture(SCREEN_TEXTURE, UV);
	
	COLOR = sample;
	
	//if (x % 3 == 0 || y % 3 == 0) {
		//
		//COLOR = vec4(0, 0, 0, 1);
		//
	//} else if (x % 3 == 1) {
		//
		//if (y % 3 == 1) {
			//COLOR = vec4(sample.r, 0, 0, 1);
		//} else {
			//COLOR = vec4(0, sample.g, 0, 1);
		//}
		//
	//} else {
		//
		//if (y % 3 == 1) {
			//COLOR = vec4(0, 0, sample.b, 1);
		//} else {
			//COLOR = vec4(0, 0, 0, 1);
		//}
	//}
}