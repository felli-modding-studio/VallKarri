#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
    #define MY_HIGHP_OR_MEDIUMP highp
#else
    #define MY_HIGHP_OR_MEDIUMP mediump
#endif

extern MY_HIGHP_OR_MEDIUMP vec2 gradient_badge;
extern MY_HIGHP_OR_MEDIUMP number time;
extern MY_HIGHP_OR_MEDIUMP vec2 uibox_pos;
extern MY_HIGHP_OR_MEDIUMP vec2 uibox_size;
extern MY_HIGHP_OR_MEDIUMP float screen_scale;

float avg(float a, float b) {
    return (a+b)/2;
}

vec4 effect( vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords )
{
    vec4 tex = colour;
    vec2 uv = (screen_coords - uibox_pos) / (uibox_size.xy);
    uv.x = uv.x * (love_ScreenSize.x/love_ScreenSize.y);
    uv.y = uv.y / (20.);

    // number low = min(tex.r, min(tex.g, tex.b));
    // number high = max(tex.r, max(tex.g, tex.b));
	// number delta = high-low -0.1;

    if (time > 2*time) {
        tex.r = 1;
    }

    // constants
    float amp = 1.;
    float sqr = 2.;
    float freq = 3.14159/15.;
    float mini = 0.8;
    float maxi = 1.2;
    vec3 goal = vec3(1, 185. / 255., 34. / 255.);
    goal *= 1.2;

    //calculations
    float square_wave = (amp / ((pow(abs(sqr), sqr * sin(freq * uv.x)))+1.)) - (amp / 2.); //sinful technique told to me by tibetan monks
    float sintime = (sin(gradient_badge.y + (pow(6.*uv.x,1.5)*square_wave) + (30.*uv.y)) + 1.) / 2.;
    sintime = ((sintime - mini) * (maxi - mini)) + mini; //change to between 0.8 and 1.2
    float factor_r = (sintime*goal.r); // i love being biased!
    float factor_g = (sintime*goal.g);
    float factor_b = (sintime*goal.b);
    tex *= 2; //true?
    tex.r *= factor_r;
    tex.g *= factor_g;
    tex.b *= factor_b;

    

    return tex;
}