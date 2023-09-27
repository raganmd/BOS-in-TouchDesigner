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

// Author @patriciogv - 2015
// http://patriciogonzalezvivo.com
float random (in vec2 _st) { 
    return fract(sin(dot(_st.xy,
                         vec2(12.9898,78.233)))* 
        43758.5453123);
}

// Based on Morgan McGuire @morgan3d
// https://www.shadertoy.com/view/4dS3Wd
float noise (in vec2 _st) {
    vec2 i = floor(_st);
    vec2 f = fract(_st);

    // Four corners in 2D of a tile
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(a, b, u.x) + 
            (c - a)* u.y * (1.0 - u.x) + 
            (d - b) * u.x * u.y;
}

#define NUM_OCTAVES 5

float fbm ( in vec2 _st) {
    float v = 0.0;
    float a = 0.5;
    vec2 shift = vec2(100.0);
    // Rotate to reduce axial bias
    mat2 rot = mat2(cos(0.5), sin(0.5), 
                    -sin(0.5), cos(0.50));
    for (int i = 0; i < NUM_OCTAVES; ++i) {
        v += a * noise(_st);
        _st = rot * _st * 2.0 + shift;
        a *= 0.5;
    }
    return v;
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
	vec2 st 		= vUV.st * 3.0;
	vec2 aspect 	= uTD2DInfos[0].res.zw / uTD2DInfos[0].res.w;
    //st              += st * abs(sin(u_time*0.1)*3.0);
	st 				*= aspect;
    vec3 color      = vec3(0.0);

    vec2 q          = vec2(0.);
    q.x             = fbm( st + 0.00*u_time);
    q.y             = fbm( st + vec2(1.0));

    vec2 r          = vec2(0.);
    r.x             = fbm( st + 1.0*q + vec2(1.7,9.2)+ 0.15*u_time );
    r.y             = fbm( st + 1.0*q + vec2(8.3,2.8)+ 0.126*u_time);

    float f         = fbm(st+r);

    color           = mix(vec3(0.101961,0.619608,0.666667),
                          vec3(0.666667,0.666667,0.498039),
                          clamp((f*f)*4.0,0.0,1.0));

    color           = mix(color,
                          vec3(0,0,0.164706),
                          clamp(length(q),0.0,1.0));

    color           = mix(color,
                          vec3(0.666667,1,1),
                          clamp(length(r.x),0.0,1.0));

    color           = (f * f * f + 0.6 * f * f + 0.5 * f) * color;

	// TDOutputSwizzle is a TouchDesigner function that helps ensure 
	// consistent behavior between mac and pc versions of touch. What's
	// important to know here is that you need to provide this function
	// with a vec4. Because our example above doesn't consider alpha, 
	// we can construct a vec4 out of our variable color, and an additional
	// value of 1.0 for the alpha channel.
	fragColor 		= TDOutputSwizzle(vec4( color, 1.0 ));
}