#version 330

// input vertex data
in vec3  a_Position;
in vec2  a_TexCoord;

// output data; will be interpolated for each fragment.
out vec2 v_TexCoord;


// Values that stay constant for the whole mesh.
uniform mat4 u_Projection;
uniform mat4 u_View;

void main()
{
	// Output position of the vertex, in clip space : MVP * position
	gl_Position =  u_Projection * u_View * vec4(a_Position, 1);
		
	// Only correct if ModelMatrix does not scale the model ! Use its inverse transpose if not.
	v_TexCoord = a_TexCoord;
}
