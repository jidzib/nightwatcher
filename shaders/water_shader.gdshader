shader_type canvas_item;

uniform float wave_speed = 1.2;
uniform float wave_scale = 100.0;
uniform float wave_strength = 0.08;

void fragment() {
    vec2 screen_pos = SCREEN_UV * wave_scale;

    float wave1 = sin(screen_pos.y + TIME * wave_speed);
    float wave2 = sin(screen_pos.x * 1.3 + TIME * wave_speed * 0.8);

    float wave = (wave1 + wave2) * 0.5;

    // Convert from [-1,1] to a tight brightness range
    float brightness = 0.95 + wave * wave_strength;

    vec4 tex = texture(TEXTURE, UV);
    tex.rgb *= brightness;

    COLOR = tex;
}
