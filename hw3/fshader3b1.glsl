#version 330

// Interpolated values from the vertex shaders
in vec2 v_TexCoord;

uniform	sampler2D u_Sampler;	// uniform variable for the texture image

out vec4 fragColor;

void main()
{

	fragColor = texture(u_Sampler, v_TexCoord);		       
}
