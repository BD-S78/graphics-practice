#version 330

// Input vertex data, different for all executions of this shader.
in vec3  a_Position;	// attribute variable: position vector

// Values that stay constant for the whole mesh.
uniform mat4 u_Projection;
uniform mat4 u_View;


void main() 
{
	// Output position of the vertex, in clip space : MVP * position
	gl_Position =  u_Projection * u_View * vec4(a_Position, 1);
		
}
