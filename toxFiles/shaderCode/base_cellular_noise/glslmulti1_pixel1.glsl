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
uniform vec2 u_mouse;

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

    // Cell positions
    vec2 point[5];
    point[0]		= vec2(0.83,0.75);
    point[1]		= vec2(0.60,0.07);
    point[2]		= vec2(0.28,0.64);
    point[3]		=  vec2(0.31,0.26);
    point[4]		= u_mouse;
    
    float m_dist 	= 1.;  // minimun distance

    // Iterate through the points positions
    for (int i = 0; i < 5; i++) {
        float dist	= distance(st, point[i]);
        
        // Keep the closer distance
        m_dist 		= min(m_dist, dist);
    }
    
    // Draw the min distance (distance field)
    color 			+= m_dist;

    // Show isolines
    //color -= step(.7,abs(sin(50.0*m_dist)))*.3;
	// TDOutputSwizzle is a TouchDesigner function that helps ensure 
	// consistent behavior between mac and pc versions of touch. What's
	// important to know here is that you need to provide this function
	// with a vec4. Because our example above doesn't consider alpha, 
	// we can construct a vec4 out of our variable color, and an additional
	// value of 1.0 for the alpha channel.
	fragColor 		= TDOutputSwizzle(vec4( color, 1.0 ));
}