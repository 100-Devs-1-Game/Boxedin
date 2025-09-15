shader_type canvas_item;

uniform float reveal_amount : hint_range(0.0, 1.0) = 0.0;

void fragment() {
    vec2 uv = UV - vec2(0.5);
    float angle = atan(uv.y, uv.x); // angle in radians
    float dist = length(uv);

    float progress = (angle + PI) / (2.0 * PI);

    if (progress > reveal_amount) {
        COLOR.a = 0.0;
    } else {
        COLOR = texture(TEXTURE, UV);
    }
}