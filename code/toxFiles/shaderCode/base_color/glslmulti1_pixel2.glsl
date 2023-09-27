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

// uniforms
uniform float u_time;

// functions
float plot (vec2 st, float pct){
  return  smoothstep( pct-0.01, pct, st.y) - 
          smoothstep( pct, pct+0.01, st.y);
}

out vec4 fragColor;
void main()
{
	vec3 colorA 	= vec3(0.149,0.141,0.912);
	vec3 colorB 	= vec3(1.000,0.833,0.224);

	// TouchDesigner provides us with a built in variable
	// that already holds the uvs for our texutre. Normally we'd 
	// you'll see this done other places with fragcoord and the
	// resolution of the scene. We could similarly derive this value
	// like this:
	// vec2 st 		= gl_FragCoord.xy / uTD2DInfos[0].res.zw;
	// here gl_FragCoord provides the pixel value, and uTD2DInfos[0].res.zw
	// provides the xy resolution of our first input.
	vec2 st 		= vUV.st;

	vec3 color 		= vec3( 0.0 );

	vec3 pct 		= vec3( st.x );

	//pct.r 			= smoothstep( 0.0, 1.0, st.x );
	//pct.g 			= sin(st.x*PI);
	//pct.b 			= pow(st.x,0.5);

    // Mix uses pct (a value from 0-1) to 
    // mix the two colors
    color 			= mix(colorA, colorB, pct); 

    // Plot transition lines for each channel
    color = mix( color, vec3(1.0,0.0,0.0), plot( st, pct.r ) );
    color = mix( color, vec3(0.0,1.0,0.0), plot( st, pct.g ) );
    color = mix( color, vec3(0.0,0.0,1.0), plot( st, pct.b ) );

	// TDOutputSwizzle is a TouchDesigner function that helps ensure 
	// consistent behavior between mac and pc versions of touch. What's
	// important to know here is that you need to provide this function
	// with a vec4. Because our example above doesn't consider alpha, 
	// we can construct a vec4 out of our variable color, and an additional
	// value of 1.0 for the alpha channel.
	fragColor 		= TDOutputSwizzle(vec4( color, 1.0 ));
}
