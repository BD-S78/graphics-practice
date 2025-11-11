#version 330

in vec2 v_TexCoord;

uniform	sampler2D u_Sampler;

out vec4 fragColor;

void main()
{

	fragColor = texture(u_Sampler, v_TexCoord);		       
}
