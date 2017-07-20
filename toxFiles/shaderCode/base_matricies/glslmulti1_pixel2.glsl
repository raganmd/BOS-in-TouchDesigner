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
mat2 rotate2d(float _angle){
    return mat2(cos(_angle),-sin(_angle),
                sin(_angle),cos(_angle));
}

float box(in vec2 _st, in vec2 _size){
    _size = vec2(0.5) - _size*0.5;
    vec2 uv = smoothstep(_size,
                        _size+vec2(0.001),
                        _st);
    uv *= smoothstep(_size,
                    _size+vec2(0.001),
                    vec2(1.0)-_st);
    return uv.x*uv.y;
}

float cross(in vec2 _st, float _size){
    return  box(_st, vec2(_size,_size/4.)) + 
            box(_st, vec2(_size/4.,_size));
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

    // move space from the center to the vec2(0.0)
    st 				-= vec2(0.5);

    // rotate the space
    st 				= rotate2d( sin(u_time)*PI ) * st;

    // move it back to the original place
    st 				+= vec2(0.5);

    // Show the coordinates of the space on the background
    // color = vec3(st.x,st.y,0.0);

    // Add the shape on the foreground
    color 			+= vec3(cross(st,0.4));


	// TDOutputSwizzle is a TouchDesigner function that helps ensure 
	// consistent behavior between mac and pc versions of touch. What's
	// important to know here is that you need to provide this function
	// with a vec4. Because our example above doesn't consider alpha, 
	// we can construct a vec4 out of our variable color, and an additional
	// value of 1.0 for the alpha channel.
	fragColor 		= TDOutputSwizzle(vec4( color, 1.0 ));
}