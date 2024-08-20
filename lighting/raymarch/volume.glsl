#include "map.glsl"
#include "../common/attenuation.glsl"
#include "../common/beerLambert.glsl"
#include "../../generative/random.glsl"
#include "../../math/const.glsl"
#include "../material/volumeNew.glsl"

/*
contributors:  Shadi El Hajj
description: Default raymarching renderer. Based on Sébastien Hillaire's paper "Physically Based Sky, Atmosphere & Cloud Rendering in Frostbite"
use: <vec4> raymarchVolume( in <vec3> rayOrigin, in <vec3> rayDirection, in <vec3> cameraForward, <vec2> st, float minDist ) 
options:
    - RAYMARCH_VOLUME_SAMPLES       256
    - RAYMARCH_VOLUME_SAMPLES_LIGHT 8
    - RAYMARCH_VOLUME_MAP_FNC       raymarchVolumeMap
    - RAYMARCH_VOLUME_DITHER        0.1
    - LIGHT_COLOR                   vec3(0.5, 0.5, 0.5)
    - LIGHT_INTENSITY               1.0
    - LIGHT_POSITION
    - LIGHT_DIRECTION
examples:
    - /shaders/lighting_raymarching_volume.frag
license: MIT License (MIT) Copyright (c) 2024 Shadi EL Hajj
*/

#ifndef LIGHT_COLOR
#if defined(GLSLVIEWER)
#define LIGHT_COLOR u_lightColor
#else
#define LIGHT_COLOR vec3(0.5, 0.5, 0.5)
#endif
#endif

#ifndef LIGHT_INTENSITY
#define LIGHT_INTENSITY 1.0
#endif

#ifndef RAYMARCH_VOLUME_SAMPLES
#define RAYMARCH_VOLUME_SAMPLES 256
#endif

#ifndef RAYMARCH_VOLUME_SAMPLES_LIGHT
#define RAYMARCH_VOLUME_SAMPLES_LIGHT 8
#endif

#ifndef RAYMARCH_VOLUME_MAP_FNC
#define RAYMARCH_VOLUME_MAP_FNC raymarchVolumeMap
#endif

#ifndef RAYMARCH_VOLUME_DITHER
#define RAYMARCH_VOLUME_DITHER 0.1
#endif

#ifndef FNC_RAYMARCH_VOLUMERENDER
#define FNC_RAYMARCH_VOLUMERENDER

vec3 shadowTransmittance(vec3 position) {
    #if defined(LIGHT_DIRECTION) || defined(LIGHT_POSITION)
    #if defined(LIGHT_DIRECTION) // directional light
    float tstepLight = RAYMARCH_MAX_DIST/float(RAYMARCH_VOLUME_SAMPLES_LIGHT);
    vec3 rayDirectionLight = LIGHT_DIRECTION;
    const float attenuationLight = 1.0;
    #else // point light
    float distToLight = distance(LIGHT_POSITION, position);
    float tstepLight = distToLight/float(RAYMARCH_VOLUME_SAMPLES_LIGHT);
    vec3 rayDirectionLight = normalize(LIGHT_POSITION - position);
    float attenuationLight = attenuation(distToLight);
    #endif

    float transmittanceLight = 1.0;
    for (int j = 0; j < RAYMARCH_VOLUME_SAMPLES_LIGHT; j++) {                
        vec3 positionLight = position + rayDirectionLight * j * tstepLight;
        VolumeMaterial resLight = RAYMARCH_VOLUME_MAP_FNC(positionLight);
        float extinctionLight = -resLight.sdf;
        float densityLight = resLight.density*tstepLight;
        transmittanceLight *= beerLambert(densityLight, extinctionLight);
    }

    return LIGHT_COLOR * LIGHT_INTENSITY * attenuationLight * transmittanceLight;
}

vec4 raymarchVolume( in vec3 rayOrigin, in vec3 rayDirection, vec2 st, float minDist) {
    float transmittance = 1.0;
    float t = RAYMARCH_MIN_DIST;
    vec3 color = vec3(0.0, 0.0, 0.0);
    vec3 position = rayOrigin;
    
    for(int i = 0; i < RAYMARCH_VOLUME_SAMPLES; i++) {
        vec3 position = rayOrigin + rayDirection * t;
        VolumeMaterial res = RAYMARCH_VOLUME_MAP_FNC(position);
        float extinction = -res.sdf;
        float tstep = RAYMARCH_MAX_DIST/float(RAYMARCH_VOLUME_SAMPLES);
        float density = res.density*tstep;
        if (t < minDist && extinction > 0.0) {
            float sampleTransmittance = beerLambert(density, extinction);
            vec3 luminance = shadowTransmittance(position);
            #else // no lighting
            vec3 luminance = 1.0;
            #endif

            // usual scattering integration
            color += res.albedo * luminance * density * transmittance; 
            
            // energy-conserving scattering integration
            //vec3 integScatt = (luminance - luminance * sampleTransmittance) / max(extinction, EPSILON);       
            //color += res.albedo * transmittance * integScatt;

            transmittance *= sampleTransmittance;
        }

        float offset = random(st)*(tstep*RAYMARCH_VOLUME_DITHER);
        t += tstep + offset;
    }

    return vec4(color, 0.0);
}

#endif
