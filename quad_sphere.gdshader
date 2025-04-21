shader_type spatial;
render_mode unshaded;

varying float x;
varying float y;

void vertex() {
	x = (UV.x - 0.5) * 2.0;
	y = (UV.y - 0.5) * 2.0;

	VERTEX.x += (1.0 - sqrt(x * x + y * y)) / 10.0;
}

void fragment() {

	if (x * x + y * y > 1.0)
		discard;

	NORMAL = vec3(sin(x * PI / 2.0), -sin(y * PI / 2.0), 1.0);
}