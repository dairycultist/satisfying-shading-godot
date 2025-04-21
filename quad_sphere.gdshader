shader_type spatial;
render_mode unshaded;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {

	float x = (UV.x - 0.5) * 2.0;
	float y = (UV.y - 0.5) * 2.0;

	if (x * x + y * y > 1.0)
		discard;

	NORMAL = vec3(x, y, 1.0);
}