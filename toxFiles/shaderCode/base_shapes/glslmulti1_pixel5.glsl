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

// uniforms
uniform float u_time;

// functions


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
	vec2 st 		= vUV.st;

	vec3 color 		= vec3( 0.0 );

	vec2 pos 		= vec2( 0.5 ) - st;

	float r 		= length( pos ) * 2.0;
	float a 		= atan( pos.y, pos.x );

	float f 		= cos( a * 3.0 );
	// f 				= abs( cos( a * 3.0 ) );
	// f 				= abs( cos( a * 2.5 ) * 0.5 + 0.3 );
	// f 				= abs( cos( a * 12.0 ) * sin( a * 10.0 ) * 0.2 + 0.5 );
	// f 	 			= smoothstep( -0.5, 1.0, cos( a * 10.0 ) ) * 0.2 + 0.5;

	// visualize the distance field
	color 			= vec3( 1.0 - smoothstep( f, f + 0.02, r ) );

	// TDOutputSwizzle is a TouchDesigner function that helps ensure 
	// consistent behavior between mac and pc versions of touch. What's
	// important to know here is that you need to provide this function
	// with a vec4. Because our example above doesn't consider alpha, 
	// we can construct a vec4 out of our variable color, and an additional
	// value of 1.0 for the alpha channel.
	fragColor 		= TDOutputSwizzle(vec4( color, 1.0 ));
}