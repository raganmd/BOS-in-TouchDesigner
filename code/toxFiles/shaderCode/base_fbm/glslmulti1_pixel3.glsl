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

// Author: @patriciogv - 2015
// Tittle: Ridge
// Some useful functions
vec3 mod289(vec3 x) { return x - floor(x * (1.0 / 289.0)) * 289.0; }
vec2 mod289(vec2 x) { return x - floor(x * (1.0 / 289.0)) * 289.0; }
vec3 permute(vec3 x) { return mod289(((x*34.0)+1.0)*x); }

//
// Description : GLSL 2D simplex noise function
//      Author : Ian McEwan, Ashima Arts
//  Maintainer : ijm
//     Lastmod : 20110822 (ijm)
//     License : 
//  Copyright (C) 2011 Ashima Arts. All rights reserved.
//  Distributed under the MIT License. See LICENSE file.
//  https://github.com/ashima/webgl-noise
// 
float snoise(vec2 v) {

    // Precompute values for skewed triangular grid
    const vec4 C = vec4(0.211324865405187,
                        // (3.0-sqrt(3.0))/6.0
                        0.366025403784439,  
                        // 0.5*(sqrt(3.0)-1.0)
                        -0.577350269189626,  
                        // -1.0 + 2.0 * C.x
                        0.024390243902439); 
                        // 1.0 / 41.0

    // First corner (x0)
    vec2 i  = floor(v + dot(v, C.yy));
    vec2 x0 = v - i + dot(i, C.xx);

    // Other two corners (x1, x2)
    vec2 i1 = vec2(0.0);
    i1 = (x0.x > x0.y)? vec2(1.0, 0.0):vec2(0.0, 1.0);
    vec2 x1 = x0.xy + C.xx - i1;
    vec2 x2 = x0.xy + C.zz;

    // Do some permutations to avoid
    // truncation effects in permutation
    i = mod289(i);
    vec3 p = permute(
            permute( i.y + vec3(0.0, i1.y, 1.0))
                + i.x + vec3(0.0, i1.x, 1.0 ));

    vec3 m = max(0.5 - vec3(
                        dot(x0,x0), 
                        dot(x1,x1), 
                        dot(x2,x2)
                        ), 0.0);

    m = m*m ;
    m = m*m ;

    // Gradients: 
    //  41 pts uniformly over a line, mapped onto a diamond
    //  The ring size 17*17 = 289 is close to a multiple 
    //      of 41 (41*7 = 287)

    vec3 x = 2.0 * fract(p * C.www) - 1.0;
    vec3 h = abs(x) - 0.5;
    vec3 ox = floor(x + 0.5);
    vec3 a0 = x - ox;

    // Normalise gradients implicitly by scaling m
    // Approximation of: m *= inversesqrt(a0*a0 + h*h);
    m *= 1.79284291400159 - 0.85373472095314 * (a0*a0+h*h);

    // Compute final noise value at P
    vec3 g = vec3(0.0);
    g.x  = a0.x  * x0.x  + h.x  * x0.y;
    g.yz = a0.yz * vec2(x1.x,x2.x) + h.yz * vec2(x1.y,x2.y);
    return 130.0 * dot(m, g);
}

#define OCTAVES 4

// Ridged multifractal
// See "Texturing & Modeling, A Procedural Approach", Chapter 12
float ridge(float h, float offset) {
    h = abs(h);     // create creases
    h = offset - h; // invert so creases are at top
    h = h * h;      // sharpen creases
    return h;
}

float ridgedMF(vec2 p) {
    float lacunarity = 2.0;
    float gain = 0.5;
    float offset = 0.9;
        
    float sum = 0.0;
    float freq = 1.0, amp = 0.5;
    float prev = 1.0;
    for(int i=0; i < OCTAVES; i++) {
        float n = ridge(snoise(p*freq), offset);
        sum += n*amp;
        sum += n*amp*prev;  // scale by previous octave
        prev = n;
        freq *= lacunarity;
        amp *= gain;
    }
    return sum;
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
	vec2 aspect 	= uTD2DInfos[0].res.zw / uTD2DInfos[0].res.w;
	st 				*= aspect;

	vec3 color 		= vec3( 0.0 );
	color 			+= ridgedMF(st * 3.0);

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