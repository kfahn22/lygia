#include "../color/space/linear2gamma.glsl"
#include "../color/space/gamma2linear.glsl"

#ifndef FIBONACCIBOKEH_ITERATIONS
#define FIBONACCIBOKEH_ITERATIONS 3
#endif

#ifndef FIBONACCIBOKEH_TYPE
#define FIBONACCIBOKEH_TYPE vec4
#endif

#ifndef FIBONACCIBOKEH_SAMPLER_FNC
#define FIBONACCIBOKEH_SAMPLER_FNC(POS_UV) texture2D(tex, POS_UV)
#endif

#ifndef FNC_FIBONACCIBOKEH
#define FNC_FIBONACCIBOKEH

FIBONACCIBOKEH_TYPE fibonacciBokeh(sampler2D tex, vec2 st, vec2 pixel, float amount) {
    FIBONACCIBOKEH_TYPE color = FIBONACCIBOKEH_TYPE(0.0);
    vec2 r = 1.0/pixel;
    vec2 uv = st * r;
    float f = 1.0 / (1.001 - amount);
    mat2 m = mat2(0.0, 0.061, 1.413, 0.0) - 0.737;

    vec2 st2 = vec2( dot(uv + uv - r, vec2(.0002,-0.001)), 0.0 );
    
    float counter = 0.0;
    for (float i = 1.0; i < 16.0; i += 1.0/i) {
        st2 *= m;
        color += gamma2linear( FIBONACCIBOKEH_SAMPLER_FNC(st + st2 * i * pixel ) * f);
        counter++;
    }
    return linear2gamma(color / counter);
}

#endif
