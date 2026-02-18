shader_type canvas_item;

uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float outline_width = 1.0;
uniform bool enabled = false;

void fragment() {
    vec4 base = texture(TEXTURE, UV);
    vec4 final_color = base;

    if (enabled) {
        if (base.a == 0.0) {
            vec2 texel = TEXTURE_PIXEL_SIZE * outline_width;

            float alpha = 0.0;
            alpha += texture(TEXTURE, UV + vec2( texel.x, 0.0)).a;
            alpha += texture(TEXTURE, UV + vec2(-texel.x, 0.0)).a;
            alpha += texture(TEXTURE, UV + vec2(0.0,  texel.y)).a;
            alpha += texture(TEXTURE, UV + vec2(0.0, -texel.y)).a;

            if (alpha > 0.0) {
                final_color = outline_color;
            } else {
                discard;
            }
        }
    }

    COLOR = final_color;
}
