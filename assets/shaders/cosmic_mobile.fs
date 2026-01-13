#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
    #define PRECISION highp
#else
    #define PRECISION mediump
#endif

// ============================================
// VERSIONE MOBILE OTTIMIZZATA
// Ridotto loop annidato da 11x11 a 5x5
// Ridotto scale da 5 a 2
// ============================================

extern PRECISION vec2 cosmic;

extern PRECISION number dissolve;
extern PRECISION number time;
extern PRECISION vec4 texture_details;
extern PRECISION vec2 image_details;
extern bool shadow;
extern PRECISION vec4 burn_colour_1;
extern PRECISION vec4 burn_colour_2;
extern PRECISION vec2 screen_size;

#define PI 3.14159265358979323846
float rand(vec2 c){
	return fract(sin(dot(c.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float noise(vec2 p, float freq ){
	float unit = 1./freq;
	vec2 ij = floor(p/unit);
	vec2 xy = mod(p,unit)/unit;
	xy = .5*(1.-cos(PI*xy));
	float a = rand((ij+vec2(0.,0.)));
	float b = rand((ij+vec2(1.,0.)));
	float c = rand((ij+vec2(0.,1.)));
	float d = rand((ij+vec2(1.,1.)));
	float x1 = mix(a, b, xy.x);
	float x2 = mix(c, d, xy.x);
	return mix(x1, x2, xy.y);
}

vec2 shift(vec2 pos, float x, float y) {
    return vec2(pos.x+x, pos.y+y);
}

float pos_sin(float i) {
    return (1.+sin(i))/2.;
}

vec4 RGBtoHSV(vec4 rgb_in)
{
    vec4 hsv;
    float minVal = min(min(rgb_in.r, rgb_in.g), rgb_in.b);
    float maxVal = max(max(rgb_in.r, rgb_in.g), rgb_in.b);
    float delta = maxVal - minVal;

    hsv.z = maxVal;

    if (maxVal != 0.0)
        hsv.y = delta / maxVal;
    else {
        hsv.y = 0.0;
        hsv.x = -1.0;
        return hsv;
    }

    if (rgb_in.r == maxVal)
        hsv.x = (rgb_in.g - rgb_in.b) / delta;
    else if (rgb_in.g == maxVal)
        hsv.x = 2.0 + (rgb_in.b - rgb_in.r) / delta;
    else
        hsv.x = 4.0 + (rgb_in.r - rgb_in.g) / delta;

    hsv.x = hsv.x * (1.0 / 6.0);
    if (hsv.x < 0.0)
        hsv.x += 1.0;

    hsv.w = rgb_in.a;

    return hsv;
}

vec4 HSVtoRGB(vec4 hsv) {
    vec4 rgb_out;

    float h = hsv.x * 6.0;
    float c = hsv.z * hsv.y;
    float x = c * (1.0 - abs(mod(h, 2.0) - 1.0));
    float m = hsv.z - c;

    if (h < 1.0) {
        rgb_out = vec4(c, x, 0.0, hsv.a);
    } else if (h < 2.0) {
        rgb_out = vec4(x, c, 0.0, hsv.a);
    } else if (h < 3.0) {
        rgb_out = vec4(0.0, c, x, hsv.a);
    } else if (h < 4.0) {
        rgb_out = vec4(0.0, x, c, hsv.a);
    } else if (h < 5.0) {
        rgb_out = vec4(x, 0.0, c, hsv.a);
    } else {
        rgb_out = vec4(c, 0.0, x, hsv.a);
    }

    rgb_out.rgb += m;

    return rgb_out;
}

vec4 hueshift(vec4 color, float amount) {
    color = RGBtoHSV(color);
    color.r = mod(amount+color.r, 1.);
    color = HSVtoRGB(color);
    return color;
}

// Ottimizzato: precalcola shift
float get_stars(vec2 uv, float offset_x) {
    float n = noise(vec2(uv.x + offset_x, uv.y), 35.);
    // pow(x,10) = x*x*x*x*x * x*x*x*x*x - ottimizzato
    float n2 = n*n;
    float n4 = n2*n2;
    float n8 = n4*n4;
    return n8*n2; // n^10
}

vec4 dissolve_mask(vec4 tex, vec2 texture_coords, vec2 uv);

vec4 effect( vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords )
{
    vec4 tex = Texel(texture, texture_coords);
	vec2 uv = (((texture_coords)*(image_details)) - texture_details.xy*texture_details.ba)/texture_details.ba;

    vec2 screen = screen_coords / screen_size;

    if (cosmic.y > cosmic.y *2.) {
        tex = vec4(0.);
    }

    // Ottimizzato: calcola exp una volta sola
    float ex = 1.5;
    tex = vec4(pow(tex.x,ex),pow(tex.y,ex),pow(tex.z,ex),tex.w);
    tex = RGBtoHSV(tex);
    tex.z = 0.9 - tex.z;
    float v = 0.9 - tex.z;
    uv += screen*(v*2.);
    tex = HSVtoRGB(tex);

    float dampen_speed = 3.;
    vec4 blue_layer = vec4(0.,0.,noise(shift(uv,0.,cosmic.y/dampen_speed), 3.0)/2.,0.);
    float purple_strength = noise(shift(uv,cosmic.y/dampen_speed,0.), 2.0);
    vec4 purple_layer = vec4(purple_strength*0.3,0.,purple_strength*0.8,0.);
    
    float star_strength = 0.;
    float orthoavg = 0.;
    float diagavg = 0.;
    
    // OTTIMIZZAZIONE: ridotto scale da 5 a 2
    float scale = 2.;
    float pixels_looped = 0.;
    vec2 pixel = vec2(1.,1.) / texture_details.zw;
    
    float cosmic_offset = cosmic.y*0.01;

    // Loop ottimizzato: da -2 a 2 invece di -5 a 5
    for (float i = -scale; i <= scale; i += 1.) {
        orthoavg += get_stars(shift(uv,pixel.x*i,0.), cosmic_offset);
        pixels_looped += 1.;
    }

    for (float j = -scale; j <= scale; j += 1.) {
        orthoavg += get_stars(shift(uv,0.,pixel.y*j), cosmic_offset);
        pixels_looped += 1.;
    }

    float circle_pixels = 0.;
    
    // OTTIMIZZAZIONE CRITICA: loop annidato ridotto da 11x11 a 5x5
    for (float i = -scale; i <= scale; i += 1.) {
        for (float j = -scale; j <= scale; j += 1.) {
            diagavg += get_stars(shift(uv,pixel.x*i,pixel.y*j), cosmic_offset);
            circle_pixels += 1.;
        }
    }

    orthoavg /= pixels_looped;
    circle_pixels /= 3.;

    star_strength = (orthoavg*5.) + (diagavg/circle_pixels);

    vec4 star_layer = vec4(star_strength);
    star_layer.a = 0.;
    
    tex += blue_layer;
    tex += purple_layer;
    tex += star_layer;
    float value = RGBtoHSV(tex).z;

    tex += (purple_layer+blue_layer)*(0.25*value);

    return dissolve_mask(tex*colour, texture_coords, uv);
}

vec4 dissolve_mask(vec4 tex, vec2 texture_coords, vec2 uv)
{
    if (dissolve < 0.001) {
        return vec4(shadow ? vec3(0.,0.,0.) : tex.xyz, shadow ? tex.a*0.3: tex.a);
    }

    float adjusted_dissolve = (dissolve*dissolve*(3.-2.*dissolve))*1.02 - 0.01;

	float t = time * 10.0 + 2003.;
	vec2 floored_uv = (floor((uv*texture_details.ba)))/max(texture_details.b, texture_details.a);
    vec2 uv_scaled_centered = (floored_uv - 0.5) * 2.3 * max(texture_details.b, texture_details.a);
	
	vec2 field_part1 = uv_scaled_centered + 50.*vec2(sin(-t / 143.6340), cos(-t / 99.4324));
	vec2 field_part2 = uv_scaled_centered + 50.*vec2(cos( t / 53.1532),  cos( t / 61.4532));
	vec2 field_part3 = uv_scaled_centered + 50.*vec2(sin(-t / 87.53218), sin(-t / 49.0000));

    float field = (1.+ (
        cos(length(field_part1) / 19.483) + sin(length(field_part2) / 33.155) * cos(field_part2.y / 15.73) +
        cos(length(field_part3) / 27.193) * sin(field_part3.x / 21.92) ))/2.;
    vec2 borders = vec2(0.2, 0.8);

    float res = (.5 + .5* cos( (adjusted_dissolve) / 82.612 + ( field + -.5 ) *3.14))
    - (floored_uv.x > borders.y ? (floored_uv.x - borders.y)*(5. + 5.*dissolve) : 0.)*(dissolve)
    - (floored_uv.y > borders.y ? (floored_uv.y - borders.y)*(5. + 5.*dissolve) : 0.)*(dissolve)
    - (floored_uv.x < borders.x ? (borders.x - floored_uv.x)*(5. + 5.*dissolve) : 0.)*(dissolve)
    - (floored_uv.y < borders.x ? (borders.x - floored_uv.y)*(5. + 5.*dissolve) : 0.)*(dissolve);

    if (tex.a > 0.01 && burn_colour_1.a > 0.01 && !shadow && res < adjusted_dissolve + 0.8*(0.5-abs(adjusted_dissolve-0.5)) && res > adjusted_dissolve) {
        if (!shadow && res < adjusted_dissolve + 0.5*(0.5-abs(adjusted_dissolve-0.5)) && res > adjusted_dissolve) {
            tex.rgba = burn_colour_1.rgba;
        } else if (burn_colour_2.a > 0.01) {
            tex.rgba = burn_colour_2.rgba;
        }
    }

    return vec4(shadow ? vec3(0.,0.,0.) : tex.xyz, res > adjusted_dissolve ? (shadow ? tex.a*0.3: tex.a) : 0.);
}

extern PRECISION vec2 mouse_screen_pos;
extern PRECISION float hovering;
extern PRECISION float screen_scale;

#ifdef VERTEX
vec4 position( mat4 transform_projection, vec4 vertex_position )
{
    if (hovering <= 0.){
        return transform_projection * vertex_position;
    }
    float mid_dist = length(vertex_position.xy - 0.5*love_ScreenSize.xy)/length(love_ScreenSize.xy);
    vec2 mouse_offset = (vertex_position.xy - mouse_screen_pos.xy)/screen_scale;
    float scale = 0.2*(-0.03 - 0.3*max(0., 0.3-mid_dist))
                *hovering*(length(mouse_offset)*length(mouse_offset))/(2. -mid_dist);

    return transform_projection * vertex_position + vec4(0.,0.,0.,scale);
}
#endif
