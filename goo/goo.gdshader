shader_type spatial;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;


void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {

	vec3 sample = textureLod(screen_texture, SCREEN_UV + NORMAL.xy * 100.0 / VIEWPORT_SIZE, 0.0).rgb;

	ALBEDO = sample;

	//vec3 center = mix(vec3(1.0, 0.3, 0.0), vec3(1.0, 0.0, 0.0) * sample, 0.8);
	//vec3 edge = mix(vec3(1.0, 0.5, 0.0), vec3(1.0, 3.0, 0.0) * sample, 0.6);
//
	//ALBEDO = mix(edge, center, smoothstep(0.4, 0.7, NORMAL.z));
	SPECULAR = 0.2;
	ROUGHNESS = 0.3;
}
