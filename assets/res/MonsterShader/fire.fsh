#ifdef GL_ES
precision mediump float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;
varying vec2 v_circle_time;

vec3 mask_color = vec3(255.0, 72.0, 72.0) / 255.0;

void main(void)
{
	vec4 color = texture2D(CC_Texture0, v_texCoord) * v_fragmentColor;
	gl_FragColor = vec4(color.rgb * mask_color * v_circle_time.x, color.a);
}