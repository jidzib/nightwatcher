shader_type canvas_item;

uniform sampler2D atlas_texture;
uniform vec4 region_rect;
uniform vec2 atlas_size;

uniform float skew = 0;
uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float outline_width = 1.0;
uniform bool enabled = true;

void vertex() {
	VERTEX.x += (1.0-UV.y) * skew;
}
//void fragment() {
    //vec4 base_color = texture(TEXTURE, UV);
//
    //// Case 1: outline disabled → draw normally
    //if (!enabled) {
        //COLOR = base_color;
    //}
//
    //// Case 2: normal sprite pixel → draw normally
    //else if (base_color.a > 0.0) {
        //COLOR = base_color;
    //}
//
    //// Case 3: transparent pixel → check neighbors for outline
    //else {
        //vec2 px = TEXTURE_PIXEL_SIZE * outline_width;
        //float alpha = 0.0;
//
        //alpha += texture(TEXTURE, UV + vec2( px.x, 0.0)).a;
        //alpha += texture(TEXTURE, UV + vec2(-px.x, 0.0)).a;
        //alpha += texture(TEXTURE, UV + vec2(0.0,  px.y)).a;
        //alpha += texture(TEXTURE, UV + vec2(0.0, -px.y)).a;
//
        //if (alpha > 0.0) {
            //COLOR = outline_color;
        //} else {
            //discard;
        //}
    //}
//}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
