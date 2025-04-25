shader_type spatial;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform float Specular : hint_range(0.0, 1.0) = 0.5;
uniform float Hardness : hint_range(1.0, 511.0, 1.0) = 50.0;
uniform vec3 BaseColor : source_color = vec3(1.0, 0.5, 0.0);
uniform vec3 HighlightColor : source_color = vec3(1.0, 0.9, 0.4);
uniform float Opacity : hint_range(0.0, 1.0) = 0.2;

uniform float refraction : hint_range(10000, 100000) = 60000.0;

// https://x.com/PBtmm/status/1263687803210215427

void vertex() {

}

void fragment() {

	vec3 cam_offset_view_dir = (VIEW_MATRIX * vec4(normalize(CAMERA_POSITION_WORLD - NODE_POSITION_WORLD), 0.0)).xyz;

	vec3 dir1 = vec3(0, 0, 1);
	vec3 dir2 = cam_offset_view_dir;
	vec3 axis = normalize(cross(dir1, dir2));

	float cos_angle = dot(dir1, dir2);
	float angle = acos(cos_angle);
	float sin_angle = sin(angle);

	// Rodrigues' Rotation Formula
	mat3 rot_matrix = mat3(
		vec3(
	    cos_angle + axis.x * axis.x * (1.0 - cos_angle),
	    axis.x * axis.y * (1.0 - cos_angle) - axis.z * sin_angle,
	    axis.x * axis.z * (1.0 - cos_angle) + axis.y * sin_angle
		),
		vec3(
	    axis.y * axis.x * (1.0 - cos_angle) + axis.z * sin_angle,
	    cos_angle + axis.y * axis.y * (1.0 - cos_angle),
	    axis.y * axis.z * (1.0 - cos_angle) - axis.x * sin_angle
		),
		vec3(
	    axis.z * axis.x * (1.0 - cos_angle) - axis.y * sin_angle,
	    axis.z * axis.y * (1.0 - cos_angle) + axis.x * sin_angle,
	    cos_angle + axis.z * axis.z * (1.0 - cos_angle)
		)
	);

    ALBEDO = rot_matrix * NORMAL;

	//vec3 sample = textureLod(
		//screen_texture,
		//SCREEN_UV + vec2(-NORMAL.x * VIEWPORT_SIZE.y, NORMAL.y * VIEWPORT_SIZE.x) / refraction,
		//0.0
	//).rgb;
//
	//float density = (1.0 - dot(NORMAL, vec3(0.0, 0.0, 1.0)));
//
	//ALBEDO = mix(mix(sample * BaseColor, BaseColor, Opacity), HighlightColor, smoothstep(0.4, 0.7, density));
}

void light() {

	vec3 L = normalize(LIGHT);
	vec3 N = normalize(NORMAL);

	float NdotL = dot(N, L) * ATTENUATION;

	vec3 V = normalize(VIEW);
	vec3 H = normalize(L + V);

	float specular = max(0.0, pow(dot(H, NORMAL), Hardness)) * Specular;
	vec3 finalSpecular = (vec3(specular) * LIGHT_COLOR / PI) * max(0.0, 1.0 - pow(1.0 - NdotL, 20));

	SPECULAR_LIGHT += finalSpecular;
	DIFFUSE_LIGHT += ATTENUATION * LIGHT_COLOR / PI;
}