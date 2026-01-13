#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
    #define PRECISION highp
#else
    #define PRECISION mediump
#endif

extern PRECISION vec2 rgb;
extern PRECISION float dissolve;
extern PRECISION float time;
extern PRECISION vec4 texture_details;
extern PRECISION vec2 image_details;
extern bool shadow;
extern PRECISION vec4 burn_colour_1;
extern PRECISION vec4 burn_colour_2;

extern PRECISION vec2 mouse_screen_pos;
extern PRECISION float hovering;
extern PRECISION float screen_scale;

vec4 dissolve_mask(vec4 tex, vec2 texture_coords, vec2 uv);

vec4 RGBtoHSV(vec4 rgb_in) {
    vec4 hsv;
    float minVal = min(min(rgb_in.r, rgb_in.g), rgb_in.b);
    float maxVal = max(max(rgb_in.r, rgb_in.g), rgb_in.b);
    float delta = maxVal - minVal;
    hsv.z = maxVal;
    if (maxVal != 0.0) {
        hsv.y = delta / maxVal;
    } else {
        hsv.y = 0.0;
        hsv.x = -1.0;
        return hsv;
    }
    if (rgb_in.r == maxVal) hsv.x = (rgb_in.g - rgb_in.b) / delta;
    else if (rgb_in.g == maxVal) hsv.x = 2.0 + (rgb_in.b - rgb_in.r) / delta;
    else hsv.x = 4.0 + (rgb_in.r - rgb_in.g) / delta;
    hsv.x = hsv.x * (1.0 / 6.0);
    if (hsv.x < 0.0) hsv.x += 1.0;
    hsv.w = rgb_in.a;
    return hsv;
}

vec4 HSVtoRGB(vec4 hsv) {
    float h = hsv.x * 6.0;
    float c = hsv.z * hsv.y;
    float x = c * (1.0 - abs(mod(h, 2.0) - 1.0));
    float m = hsv.z - c;
    vec3 res;
    if (h < 1.0) res = vec3(c, x, 0.0);
    else if (h < 2.0) res = vec3(x, c, 0.0);
    else if (h < 3.0) res = vec3(0.0, c, x);
    else if (h < 4.0) res = vec3(0.0, x, c);
    else if (h < 5.0) res = vec3(x, 0.0, c);
    else res = vec3(c, 0.0, x);
    return vec4(res + m, hsv.w);
}

#define PI 3.14159265358979323846

float rand(vec2 c){
    return fract(sin(dot(c.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float noise(vec2 p, float freq ){
    float unit = 1.0/freq;
    vec2 ij = floor(p/unit);
    vec2 xy = mod(p,unit)/unit;
    xy = 0.5*(1.0-cos(PI*xy));
    float a = rand((ij+vec2(0.0,0.0)));
    float b = rand((ij+vec2(1.0,0.0)));
    float c = rand((ij+vec2(0.0,1.0)));
    float d = rand((ij+vec2(1.0,1.0)));
    float x1 = mix(a, b, xy.x);
    float x2 = mix(c, d, xy.x);
    return mix(x1, x2, xy.y);
}

float pNoise(vec2 p, int res){
    float persistance = 0.5;
    float n = 0.0;
    float normK = 0.0;
    float f = 4.0;
    float amp = 1.0;
    for (int i = 0; i < 50; i++){
        if (i >= res) break;
        n += amp * noise(p, f);
        f *= 2.0;
        normK += amp;
        amp *= persistance;
    }
    float nf = n / normK;
    return nf * nf * nf * nf;
}

vec2 shift(vec2 pos, float x, float y) {
    return vec2(pos.x+x, pos.y+y);
}

vec4 effect( vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords )
{
    vec4 tex = Texel(texture, texture_coords);
    vec2 uv = (((texture_coords)*(image_details)) - texture_details.xy*texture_details.ba)/texture_details.ba;

    vec4 col = RGBtoHSV(vec4(1.0, 0.0, 0.0, tex.a));
    float avg = (tex.r + tex.g + tex.b) / 3.0;

    // CORREZIONE QUI: Usiamo int(1) per essere sicuri al 100%
    float noise_value = pNoise(screen_coords * 0.01, 1) * 2.0;
    col.r = mod((screen_coords.x * 0.01) + (noise_value * 0.7), 1.0);
    col.g = 1.0 - pNoise(shift(screen_coords * 0.01, rgb.y * 0.05, 0.0), 1);
    col.b = avg * 1.5;

    float val = RGBtoHSV(tex).z;
    tex = ((1.0 - val) * HSVtoRGB(col)) + ((val) * tex);

    return dissolve_mask(tex * colour, texture_coords, uv);
}

vec4 dissolve_mask(vec4 tex, vec2 texture_coords, vec2 uv)
{
    if (dissolve < 0.001) {
        return vec4(shadow ? vec3(0.0,0.0,0.0) : tex.xyz, shadow ? tex.a*0.3: tex.a);
    }
    float adjusted_dissolve = (dissolve*dissolve*(3.0-2.0*dissolve))*1.02 - 0.01;
    float t = time * 10.0 + 2003.0;
    vec2 floored_uv = (floor((uv*texture_details.ba)))/max(texture_details.b, texture_details.a);
    vec2 uv_scaled_centered = (floored_uv - 0.5) * 2.3 * max(texture_details.b, texture_details.a);
    
    vec2 field_part1 = uv_scaled_centered + 50.0*vec2(sin(-t / 143.6340), cos(-t / 99.4324));
    vec2 field_part2 = uv_scaled_centered + 50.0*vec2(cos( t / 53.1532),  cos( t / 61.4532));
    vec2 field_part3 = uv_scaled_centered + 50.0*vec2(sin(-t / 87.53218), sin(-t / 49.0000));

    float field = (1.0 + (cos(length(field_part1) / 19.483) + sin(length(field_part2) / 33.155) * cos(field_part2.y / 15.73) + cos(length(field_part3) / 27.193) * sin(field_part3.x / 21.92) ))/2.0;
    vec2 borders = vec2(0.2, 0.8);

    float res = (0.5 + 0.5* cos( (adjusted_dissolve) / 82.612 + ( field + -0.5 ) *3.14))
    - (floored_uv.x > borders.y ? (floored_uv.x - borders.y)*(5.0 + 5.0*dissolve) : 0.0)*(dissolve)
    - (floored_uv.y > borders.y ? (floored_uv.y - borders.y)*(5.0 + 5.0*dissolve) : 0.0)*(dissolve)
    - (floored_uv.x < borders.x ? (borders.x - floored_uv.x)*(5.0 + 5.0*dissolve) : 0.0)*(dissolve)
    - (floored_uv.y < borders.x ? (borders.x - floored_uv.y)*(5.0 + 5.0*dissolve) : 0.0)*(dissolve);

    if (tex.a > 0.01 && burn_colour_1.a > 0.01 && !shadow && res < adjusted_dissolve + 0.8*(0.5-abs(adjusted_dissolve-0.5)) && res > adjusted_dissolve) {
        if (!shadow && res < adjusted_dissolve + 0.5*(0.5-abs(adjusted_dissolve-0.5)) && res > adjusted_dissolve) {
            tex.rgba = burn_colour_1.rgba;
        } else if (burn_colour_2.a > 0.01) {
            tex.rgba = burn_colour_2.rgba;
        }
    }
    return vec4(shadow ? vec3(0.0,0.0,0.0) : tex.xyz, res > adjusted_dissolve ? (shadow ? tex.a*0.3: tex.a) : 0.0);
}

#ifdef VERTEX
vec4 position( mat4 transform_projection, vec4 vertex_position )
{
    if (hovering <= 0.0){
        return transform_projection * vertex_position;
    }
    float mid_dist = length(vertex_position.xy - 0.5*love_ScreenSize.xy)/length(love_ScreenSize.xy);
    vec2 mouse_offset = (vertex_position.xy - mouse_screen_pos.xy)/screen_scale;
    float scale = 0.2*(-0.03 - 0.3*max(0.0, 0.3-mid_dist)) * hovering*(length(mouse_offset)*length(mouse_offset))/(2.0 -mid_dist);
    return transform_projection * vertex_position + vec4(0.0,0.0,0.0,scale);
}
#endif
