// The Book of Shaders | https://thebookofshaders.com/
// Patricio Gonzalez Vivo | http://patriciogonzalezvivo.com/
// Jen Lowe | http://jenlowe.net/

// Ported to TouchDesigner by Matthew Ragan
// matthewragan.com

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
// As a disclaimer, I don't own any of this code. This is really
// just a passion project to help build bridges between the larger
// GL community and TouchDesigner developers. If you're new to GLSL
// this is a great place to get a handle on how things work and
// experiment.
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

#define PI 3.14159265359
#define TWO_PI 6.28318530718

// uniforms
uniform float u_time;

// functions
// Author: Patricio Gonzalez Vivo

// Title: Interaction of color - VII
// Chapter: 2 different color look alike - substraction of color

// "Recongnizing this, one is able to push light and/or hue,
//	by the use of constrasts, away from their first appearance
//	towards the opposite qualities.
//	Since this amounts virtaully to adding opposite qualities,
// 	it follows that one might achive parallel effects
//	by substracting those qualities not desired."
// 															Josef Albers

float rect(in vec2 st, in vec2 size){
	size = 0.25-size*0.25;
    vec2 uv = step(size,st*(1.0-st));
	return uv.x*uv.y;
}

out vec4 fragColor;
void main()
{
	// TouchDesigner provides us with a built in variable
	// that already holds the uvs for our texutre. Normally we'd 
	// you'll see this done other places with fragcoord and the
	// resolution of the scene. We could similarly derive this value
	// like this:
	// vec2 st 		= gl_FragCoord.xy / uTD2DInfos[0].res.zw;
	// here gl_FragCoord provides the pixel value, and uTD2DInfos[0].res.zw
	// provides the xy resolution of our first input.
	vec2 st 					= vUV.st;
			
	vec3 color 					= vec3( 0.0 );

    vec3 influenced_color_a 	= vec3(0.880,0.793,0.581);
    vec3 influenced_color_b 	= vec3(0.654,0.760,0.576);
    
    vec3 influencing_color_A 	= vec3(0.980,0.972,0.896); 
    vec3 influencing_color_B 	= vec3(0.036,0.722,0.790);
    
    color 						= mix(influencing_color_A,
          						           influencing_color_B,
          						           step(.5,1.-st.y));
    						
    color 						= mix(color,
          						     influenced_color_a,
          						     rect(st+vec2(.0,-0.25),vec2(0.030,0.010)));
    						
    color 						= mix(color,
          						     influenced_color_b,
          						     rect(st+vec2(.0,0.25),vec2(0.030,0.010)));
    
    color 						= mix(color,
          						     mix(influenced_color_a,
          						           influenced_color_b,
          						           step(.5,1.-st.y)),
          						     rect(st+vec2(0.0,0.),vec2(0.01,0.02)));
						
	// TDOutputSwizzle is a TouchDesigner function that helps ensure 
	// consistent behavior between mac and pc versions of touch. What's
	// important to know here is that you need to provide this function
	// with a vec4. Because our example above doesn't consider alpha, 
	// we can construct a vec4 out of our variable color, and an additional
	// value of 1.0 for the alpha channel.
	fragColor 		= TDOutputSwizzle(vec4( color, 1.0 ));
}
