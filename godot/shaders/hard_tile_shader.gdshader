shader_type canvas_item;

uniform sampler2D tiling_texture;
// pass global_transform like:
// material.set_shader_param("global_transform", get_global_transform())
// https://docs.godotengine.org/en/stable/tutorials/shading/shading_reference/canvas_item_shader.html#vertex-built-ins
uniform mat4 global_transform;
varying vec2 world_position;

const vec3 black_rgb = vec3(0.0, 0.0, 0.0);

void vertex() {
    world_position = (global_transform * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
    vec4 color = texture(tiling_texture, world_position / 256.0).rgba;
	vec4 tex_color = texture(TEXTURE, UV).rgba;
	if (tex_color.a < 0.01) {
		COLOR.a = 0.0;
	} else if (tex_color.a < 0.99) {
		COLOR.rgb = mix(color.rgb, black_rgb, (1.0 - tex_color.a) / 1.5);
	} else {
		COLOR = color;
	}
}
