shader_type spatial;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform float redVal : hint_range(0, 1) = 1.0;
uniform float greenVal : hint_range(0, 1) = 1.0;
uniform float blueVal : hint_range(0, 1) = 1.0;

// https://x.com/PBtmm/status/1263687803210215427

void vertex() {
	// Called for every vertex the material is visible on.
}

// https://godotshaders.com/shader/color-manipulator/
mat4 saturationMatrix( float _saturation ){
    vec3 luminance = vec3( 0.3086, 0.6094, 0.0820 );
    float oneMinusSat = 1.0 - _saturation;

    vec3 red = vec3( luminance.x * oneMinusSat );
    red+= vec3(_saturation, 0, 0)*redVal;
    vec3 green = vec3( luminance.y * oneMinusSat );
    green += vec3( 0,_saturation, 0 )*greenVal;
    vec3 blue = vec3( luminance.z * oneMinusSat );
    blue += vec3( 0, 0,_saturation )*blueVal;

    return mat4(vec4(red, 0),vec4(green,0),vec4(blue,0),vec4(0, 0, 0, 1));
}

void fragment() {

	vec3 sample = textureLod(
		screen_texture,
		SCREEN_UV + vec2(NORMAL.x * VIEWPORT_SIZE.y, -NORMAL.y * VIEWPORT_SIZE.x) / 20000.0,
		0.0
	).rgb;

	ALBEDO = sample;

	//vec3 center = (vec4(sample, 0.0) * saturationMatrix(1.0)).rgb;
	//vec3 edge = vec3(1.0, 3.0, 0.0) * sample;
//
	//ALBEDO = mix(edge, center, smoothstep(0.4, 0.7, NORMAL.z));
	//SPECULAR = 0.2;
	//ROUGHNESS = 0.3;
}
