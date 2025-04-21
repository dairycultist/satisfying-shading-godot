shader_type spatial;

// https://docs.godotengine.org/en/stable/tutorials/shaders/screen-reading_shaders.html

uniform sampler2D NORMAL_TEX : hint_normal_roughness_texture, repeat_disable, filter_nearest;

uniform float SIGMA: hint_range(0.1, 20.0) = 3.3;
uniform float RESOLUTION: hint_range(0.1, 20.0) = 3.3;
uniform vec3 BASE_COLOR : source_color = vec3(1.0, 0.0, 0.0);

// https://godotshaders.com/shader/gaussian-blur-2/

float gaussian_distribution(float x, float STD){ // STD stands for standard deviation
	return exp(-(x*x)/(2.*STD*STD))/(sqrt(2.*PI)*STD);
}

vec3 blurred_normal(vec2 pos, vec2 pixel_size, float sigmaUsed) {

	int radius = int(round(3.0 * sigmaUsed));

    vec3 blurredPixel = vec3(0.0);
    float total_weight = 0.0;

    for(int x = -radius ; x <= radius; x++) {
        for(int y = -radius; y <= radius; y++) {

			vec2 offset = vec2(float(x), float(y)) * pixel_size;
			vec2 changedPos = pos + offset;

			float weight = gaussian_distribution(float(x), sigmaUsed) * gaussian_distribution(float(y), sigmaUsed);

			blurredPixel += texture(NORMAL_TEX, changedPos).rgb * weight;
			total_weight += weight;
        }
    }

	blurredPixel /= total_weight;
    return blurredPixel;
}

varying float x;
varying float y;

void vertex() {

	// billboard (thanks to https://godotshaders.com/shader/voronoi-guard-effect-shader/)
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(INV_VIEW_MATRIX[0], INV_VIEW_MATRIX[1], INV_VIEW_MATRIX[2], MODEL_MATRIX[3]);
	MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);

	// for blending later
	x = (UV.x - 0.5) * 2.0;
	y = (UV.y - 0.5) * 2.0;

	VERTEX.z += (1.0 - sqrt(x * x + y * y)) / 10.0;
}

void fragment() {

	if (x * x + y * y > 1.0)
		discard;

	vec3 screen_normal = blurred_normal(SCREEN_UV, RESOLUTION / VIEWPORT_SIZE, SIGMA);

    screen_normal = screen_normal * 2.0 - 1.0;

	ALBEDO = BASE_COLOR;
    NORMAL = screen_normal;

	METALLIC = 0.0;
	SPECULAR = 0.6;
	ROUGHNESS = 0.4;
}