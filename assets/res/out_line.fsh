#ifdef GL_ES
precision mediump float;
#endif

varying vec2 v_texCoord;
varying vec4 v_fragmentColor;

uniform vec2 resolution;
uniform vec3 u_color;

void main()
{	
	vec2 unit = 1.0 / resolution.xy;
	float t1 = abs(CC_SinTime[3]);
    vec4 accum = vec4(0.0);
    vec4 normal = vec4(0.0);
    
    normal = texture2D(CC_Texture0, vec2(v_texCoord.x, v_texCoord.y));
    
    accum += texture2D(CC_Texture0, vec2(v_texCoord.x - unit.x, v_texCoord.y - unit.y));
    accum += texture2D(CC_Texture0, vec2(v_texCoord.x + unit.x, v_texCoord.y - unit.y));
    accum += texture2D(CC_Texture0, vec2(v_texCoord.x + unit.x, v_texCoord.y + unit.y));
    accum += texture2D(CC_Texture0, vec2(v_texCoord.x - unit.x, v_texCoord.y + unit.y));
    
    accum *= 1.75 * t1;
    accum.rgb =  u_color * accum.a;
    accum.a = normal.a * t1;
    
	normal = ( accum * (1.0 - normal.a)) + (normal * normal.a);
    
    gl_FragColor = v_fragmentColor * normal;
}

