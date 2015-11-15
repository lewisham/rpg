#ifdef GL_ES
precision mediump float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;
varying vec2 v_circle_time;

void main(void)
{
	vec4 color1 = texture2D(CC_Texture0, v_texCoord) * v_fragmentColor;
	float brightness = (color1.r + color1.g + color1.b) * (1. / 3.);
	float gray = 1.5 * brightness;
	gl_FragColor = vec4(vec3(gray, gray, gray) * vec3(0.8,1.2,1.5) * v_circle_time.x, color1.a);
}