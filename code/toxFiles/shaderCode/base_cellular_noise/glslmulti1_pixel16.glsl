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

// Cellular noise ("Worley noise") in 2D in GLSL.
// Copyright (c) Stefan Gustavson 2011-04-19. All rights reserved.
// This code is released under the conditions of the MIT license.
// See LICENSE file for details.

// uniforms
uniform float u_time;
uniform vec2 u_mouse;

// functions
#define PI 3.1415926535897932384626433832795

//this is a basic Pseudo Random Number Generator
float hash(in float n)
{
    return fract(sin(n)*43758.5453123);
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
	vec2 xy 		    = ( vUV.st * 2.0 ) - 1;
    vec3 color          = vec3(0.0);

    //rotating light 
    vec3 center         = vec3( sin( u_time ), 1., cos( u_time * .5 ) );
    
    //temporary vector
    vec3 pp             = vec3(0.);

    //maximum distance of the surface to the center (try a value of 0.1 for example)
    float length        = 4.;
    
    //this is the number of cells
    const float count   = 100.;
    
    for( float i = 0.; i < count; i+=1. )
    {
        //random cell: create a point around the center
        
        //gets a 'random' angle around the center 
        float an        = sin( u_time * PI * .00001 ) - hash( i ) * PI * 2.;
        
        //gets a 'random' radius ( the 'spacing' between cells )
        float ra        = sqrt( hash( an ) ) * .5;

        //creates a temporary 2d vector
        vec2 p          = vec2( center.x + cos( an ) * ra, center.z + sin( an ) * ra );

        //finds the closest cell from the fragment's XY coords
        
        //compute the distance from this cell to the fragment's coordinates
        float di        = distance( xy, p );
        
        //and check if this length is inferior to the minimum length
        length          = min( length, di );
        
        //if this cell was the closest
        if( length == di )
        {
            //stores the XY values of the cell and compute a 'Z' according to them
            pp.xy       = p;
            pp.z        = i / count * xy.x * xy.y;
        }
    }

    //shimmy shake:
    //uses the temp vector's coordinates and uses the angle and the temp vector
    //to create light & shadow (quick & dirty )
    vec3 shade          = vec3( 1. ) * ( 1. - max( 0.0, dot( pp, center ) ) );
    
    color               = vec3(pp+shade);

	// TDOutputSwizzle is a TouchDesigner function that helps ensure 
	// consistent behavior between mac and pc versions of touch. What's
	// important to know here is that you need to provide this function
	// with a vec4. Because our example above doesn't consider alpha, 
	// we can construct a vec4 out of our variable color, and an additional
	// value of 1.0 for the alpha channel.
	fragColor 		= TDOutputSwizzle(vec4( color, 1.0 ));
}