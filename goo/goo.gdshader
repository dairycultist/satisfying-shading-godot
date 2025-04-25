shader_type spatial;
render_mode depth_prepass_alpha, ambient_light_disabled;

uniform float Specular : hint_range(0.0, 1.0) = 0.5;
uniform float Hardness : hint_range(1.0, 511.0, 1.0) = 50.0;

vec3 reflectionVector(vec3 normal){
	normal *= vec3(1,-1,-1);
	vec3 asd = reflect(vec3(0,0,1), normal);
	vec3 reflection = asd+vec3(1,1,0)*.5;

	return reflection;
}

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform float refraction : hint_range(10000, 100000) = 60000.0;

// https://x.com/PBtmm/status/1263687803210215427

void fragment() {

	//vec3 sample = textureLod(
		//screen_texture,
		//SCREEN_UV + vec2(-NORMAL.x * VIEWPORT_SIZE.y, NORMAL.y * VIEWPORT_SIZE.x) / refraction,
		//0.0
	//).rgb;

	float density = (1.0 - dot(NORMAL, vec3(0.0, 0.0, 1.0)));

	ALBEDO = vec3(1.0, 0.3, 0.0);

	//vec3 center = (vec4(sample, 0.0) * saturationMatrix(1.0)).rgb;
	//vec3 edge = vec3(1.0, 3.0, 0.0) * sample;
//
	//ALBEDO = mix(edge, center, smoothstep(0.4, 0.7, NORMAL.z));
}

void light() {

	vec3 L = normalize(LIGHT);
	vec3 N = normalize(NORMAL);

	float NdotL = dot(N, L) * ATTENUATION;

	vec3 V = normalize(VIEW);
	vec3 H = normalize(L + V);

	float specular = max(pow(dot(H, NORMAL), Hardness), 0.0) * Specular;
	vec3 finalSpecular = (vec3(specular) * LIGHT_COLOR / PI) * max(1.0 - pow(1.0 - NdotL, 20), 0.0);

	SPECULAR_LIGHT = finalSpecular + SPECULAR_LIGHT;
	DIFFUSE_LIGHT = ATTENUATION * LIGHT_COLOR / PI;
}