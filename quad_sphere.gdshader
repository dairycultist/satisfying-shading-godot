shader_type spatial;
render_mode unshaded;

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

	NORMAL = vec3(sin(x * PI / 2.0), -sin(y * PI / 2.0), 1.0);
}