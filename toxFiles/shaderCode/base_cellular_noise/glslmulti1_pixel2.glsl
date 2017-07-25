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

// Author: @patriciogv
// Title: CellularNoise

// uniforms
uniform float u_time;
uniform vec2 u_mouse;

// functions
vec2 random2( vec2 p ) {
    return fract(sin(vec2(dot(p,vec2(127.1,311.7)),dot(p,vec2(269.5,183.3))))*43758.5453);
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
	vec2 st 		= vUV.st;

	vec3 color 		= vec3( 0.0 );

    // Scale 
    st              *= 3.;
    
    // Tile the space
    vec2 i_st       = floor(st);
    vec2 f_st       = fract(st);

    vec2 point      = random2(i_st);
    vec2 diff       = point - f_st;
    
    float dist      = length(diff);

    // Draw the min distance (distance field)
    color           += dist;

    // Draw cell center
    color           += 1.-step(.02, dist);
    
    // Draw grid
    color.r         += step(.98, f_st.x) + step(.98, f_st.y);
    
    // Show isolines
    // color -= step(.7,abs(sin(27.0*dist)))*.5;

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