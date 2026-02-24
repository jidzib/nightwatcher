shader_type canvas_item;

uniform float strength : hint_range(0.0, 1.0) = 0.2;
uniform sampler2D screen_texture : hint_screen_texture;

void fragment() {
    vec4 screen_color = texture(screen_texture, SCREEN_UV);

    // Example: darken screen
    screen_color.rgb *= (1.0 - strength);

    COLOR = screen_color * vec4(0.5, 0.1, 0.0, 0.1);
}