#ifdef GL_ES
precision mediump float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;
varying vec2 v_circle_time;

vec4 glass_color = vec4(86.0, 255.0, 96.0, 192.0) / 255.0;

void main(void)
{
	vec4 color = texture2D(CC_Texture0, v_texCoord) * v_fragmentColor;
	float brightness = (color.r + color.g + color.b) * (1. / 3.);
	vec3 col = (color.rgb * glass_color.a + (1.0 - glass_color.a) * glass_color.rgb) * brightness * 1.5;
	gl_FragColor = vec4(col * v_circle_time.x, color.a);
}