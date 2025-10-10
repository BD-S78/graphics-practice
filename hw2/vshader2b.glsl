#version 330

in	vec2	a_Position;	// attribute variable: position vector
in	vec3	a_Color;	// attribute variable: color vector

out	vec4	v_Color;	// varying variable for passing color to fragment shader

uniform	mat4	u_Modelview;	// uniform variable for passing modelview  matrix
uniform	mat4	u_Projection;	// uniform variable for passing projection matrix
uniform	float	u_Theta;	// Theta parameter
uniform	int	u_Twist;	// Twist flag

void main() 
{
	v_Color = vec4(a_Color, 1.0);

	float d = 1.0;
	if(u_Twist == 1) {
		d = a_Position[0]*a_Position[0]+ a_Position[1]*a_Position[1];
		float angle = d * u_Theta;
		float s = sin(angle);
		float c = cos(angle);

		vec2 pos = vec2(a_Position.x * c - a_Position.y * s,
				a_Position.x * s + a_Position.y * c);
        gl_Position = u_Projection * vec4(pos, 0, 1);



	}
	
	else {
	gl_Position = u_Projection * u_Modelview * vec4(a_Position, 0.0, 1.0);
	}
}
