#version 330

// Input vertex data, different for all executions of this shader.
in vec3  a_Position;	// attribute variable: position vector
in vec3  a_Color;	// attribute variable: color vector
in vec3  a_Normal;


// Values that stay constant for the whole mesh.
uniform mat4 u_MVP;
uniform mat4 u_View;
uniform vec3 u_LightInvDirection;
uniform mat4 u_DepthBiasMVP;



// Output data ; will be interpolated for each fragment.
out vec3 vColor;
out vec3 Position_worldspace;
out vec3 Normal_cameraspace;
out vec3 EyeDirection_cameraspace;
out vec3 LightDirection_cameraspace;
out vec4 ShadowCoord;



void main()
{

	// Output position of the vertex, in clip space : MVP * position
	gl_Position = u_MVP * vec4(a_Position, 1.0);
	
	// Position of the vertex, in worldspace : M * position
	Position_worldspace = a_Position;

	// Vector that goes from the vertex to the camera, in camera space.
	// In camera space, the camera is at the origin (0,0,0).
	vec3 vertexPosition_cameraspace = (u_View * vec4(a_Position, 1.0)).xyz;
	EyeDirection_cameraspace = normalize(-(vertexPosition_cameraspace));

	// Vector that goes from the vertex to the light, in camera space
	vec3 LightPosition_cameraspace = (u_View * vec4(u_LightInvDirection, 1.0)).xyz; 
    LightDirection_cameraspace = normalize((u_View * vec4(u_LightInvDirection, 0.0)).xyz);

	// Normal of the the vertex, in camera space
	Normal_cameraspace = (u_View * vec4(a_Normal, 0.0)).xyz;

	// Shadow Coordinates
	ShadowCoord = u_DepthBiasMVP * vec4(a_Position, 1.0);
	
	vColor = a_Color;
}
