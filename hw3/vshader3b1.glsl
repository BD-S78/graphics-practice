#version 330

in vec3  a_Position;
in vec2  a_TexCoord;


uniform mat4 u_Projection;
uniform mat4 u_View;

out vec2 v_TexCoord;


void main()
{
	gl_Position =  u_Projection * u_View * vec4(a_Position, 1);
		

	v_TexCoord = a_TexCoord;
}
