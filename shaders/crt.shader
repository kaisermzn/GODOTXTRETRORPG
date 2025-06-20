shader_type canvas_item;

void fragment() {
    vec2 uv = UV;
    COLOR = texture(TEXTURE, uv);
    float scanline = sin(uv.y * 800.0) * 0.1;
    COLOR.rgb -= scanline;
}
