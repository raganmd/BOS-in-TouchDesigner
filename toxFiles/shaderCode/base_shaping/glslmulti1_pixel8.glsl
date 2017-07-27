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

#define IN1RESOLUTION uTD2DInfos[0].res.zw
// uniforms
uniform float u_time;

// functions
// Author @kyndinfo - 2016
// Title: Quadratic Bezier
// http://www.kynd.info
//
// Original bezier function by Golan Levin and Collaborators
// http://www.flong.com/texts/code/shapers_bez/

float quadraticBezier (float x, vec2 a){
  // adapted from BEZMATH.PS (1993)
  // by Don Lancaster, SYNERGETICS Inc. 
  // http://www.tinaja.com/text/bezmath.html

  float epsilon = 0.00001;
  a.x = clamp(a.x,0.0,1.0); 
  a.y = clamp(a.y,0.0,1.0); 
  if (a.x == 0.5){
    a += epsilon;
  }
  
  // solve t from x (an inverse operation)
  float om2a = 1.0 - 2.0 * a.x;
  float t = (sqrt(a.x*a.x + om2a*x) - a.x)/om2a;
  float y = (1.0-2.0*a.y)*(t*t) + (2.0*a.y)*t;
  return y;
}

float lineSegment(vec2 p, vec2 a, vec2 b) {
    vec2 pa = p - a, ba = b - a;
    float h = clamp( dot(pa,ba)/dot(ba,ba), 0.0, 1.0 );
    return smoothstep(0.0, 1.0 / IN1RESOLUTION.x, length(pa - ba*h));
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
	vec3 color 		= vec3(0.0);

	float px 		= 1.0 / IN1RESOLUTION.y;
    
    // control point
    vec2 cp 	= vec2(cos(u_time),sin(u_time)) * 0.45 + 0.5;
    float l 	= quadraticBezier(st.x, cp);
    color 		= vec3(smoothstep(l, l+px, st.y));
    
    // draw control point
    color 		= mix(vec3(0.5), color, lineSegment(st, vec2(0.0), cp));
    color 		= mix(vec3(0.5), color, lineSegment(st, vec2(1.0), cp));
    float d 	= distance(cp, st);
    color 		= mix(vec3(1.0,0.0,0.0), color, smoothstep(0.01,0.01+px,d));

	// TDOutputSwizzle is a TouchDesigner function that helps ensure 
	// consistent behavior between mac and pc versions of touch. What's
	// important to know here is that you need to provide this function
	// with a vec4. Because our example above doesn't consider alpha, 
	// we can construct a vec4 out of our variable color, and an additional
	// value of 1.0 for the alpha channel.
	fragColor 		= TDOutputSwizzle(vec4( color, 1.0 ));
}
