#version 330

// Interpolated values from the vertex shaders
in vec3 vColor;
in vec3 Position_worldspace;
in vec3 Normal_cameraspace;
in vec3 EyeDirection_cameraspace;
in vec3 LightDirection_cameraspace;
in vec4 ShadowCoord;

out vec4 fragColor;

// Values that stay constant for the whole mesh.
uniform sampler2DShadow u_shadowMap;


vec2 poissonDisk[16] = vec2[]( 
   vec2( -0.94201624, -0.39906216 ), 
   vec2( 0.94558609, -0.76890725 ), 
   vec2( -0.094184101, -0.92938870 ), 
   vec2( 0.34495938, 0.29387760 ), 
   vec2( -0.91588581, 0.45771432 ), 
   vec2( -0.81544232, -0.87912464 ), 
   vec2( -0.38277543, 0.27676845 ), 
   vec2( 0.97484398, 0.75648379 ), 
   vec2( 0.44323325, -0.97511554 ), 
   vec2( 0.53742981, -0.47373420 ), 
   vec2( -0.26496911, -0.41893023 ), 
   vec2( 0.79197514, 0.19090188 ), 
   vec2( -0.24188840, 0.99706507 ), 
   vec2( -0.81409955, 0.91437590 ), 
   vec2( 0.19984126, 0.78641367 ), 
   vec2( 0.14383161, -0.14100790 ) 
);


void main()
{
	// Light emission properties
	vec3 LightColor = vec3(1.0, 1.0, 1.0);
	float LightPower = 0.8f;
	
	// Material properties
	vec3 MaterialDiffuseColor = vColor;
	vec3 MaterialAmbientColor = vec3(0.2, 0.2, 0.2) * MaterialDiffuseColor;
	vec3 MaterialSpecularColor = vec3(0.3, 0.3, 0.3);

	// Normal of the computed fragment, in camera space
	vec3 n = normalize(Normal_cameraspace);

	// Direction of the light (from the fragment to the light)
	vec3 l = normalize(LightDirection_cameraspace);

	// Cosine of the angle between the normal and the light direction, 
	// clamped above 0
	//  - light is at the vertical of the triangle -> 1
	//  - light is perpendiular to the triangle -> 0
	//  - light is behind the triangle -> 0
	float cosTheta = clamp(dot(n, l), 0.0, 1.0);
	
	// Eye vector (towards the camera)
	vec3 E = normalize(EyeDirection_cameraspace);

	// Direction in which the triangle reflects the light
	vec3 R = reflect(-l, n);

	// Cosine of the angle between the Eye vector and the Reflect vector,
	// clamped to 0
	//  - Looking into the reflection -> 1
	//  - Looking elsewhere -> < 1
	float cosAlpha = clamp(dot(E, R), 0.0, 1.0);
	
	float visibility = 1.0;

	// ...variable bias
	float bias = 0.005 * tan(acos(cosTheta));
	bias = clamp(bias, 0.0, 0.01);

	// Sample the shadow map 4 times
	for (int i=0; i<4; ++i) {
		// use either :
		//  - Always the same samples.
		//    Gives a fixed pattern in the shadow, but no noise
		// being fully in the shadow will eat up 4*0.2 = 0.8
		// 0.2 potentially remain, which is quite dark.
		visibility -= 0.2*(1.0-texture( u_shadowMap, vec3(ShadowCoord.xy + poissonDisk[i]/1800.0,  (ShadowCoord.z-bias)/ShadowCoord.w) ));

	}
	
	// Ambient : simulates indirect lighting
	// Diffuse : "color" of the object
	// Specular : reflective highlight, like a mirror

	fragColor = vec4((MaterialAmbientColor +
		       visibility * LightPower * cosTheta * MaterialDiffuseColor * LightColor +
		       visibility * LightPower * pow(cosAlpha, 5) * MaterialSpecularColor * LightColor), 1.0);
		       


}
