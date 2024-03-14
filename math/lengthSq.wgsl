/*
contributors: Patricio Gonzalez Vivo
description: Squared length
use:
    - lengthSq2(v: vec2f) -> f32
    - lengthSq3(v: vec3f) -> f32
    - lengthSq4(v: vec4f) -> f32
*/

fn lengthSq2(v: vec2f) -> f32 { return dot(v, v); }
fn lengthSq3(v: vec3f) -> f32 { return dot(v, v); }
fn lengthSq4(v: vec4f) -> f32 { return dot(v, v); }
