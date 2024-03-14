/*
contributors: Patricio Gonzalez Vivo
description: round a value to the nearest integer
use: 
    - round(x: f32) -> f32
    - round2(x: vec2f) -> vec2f
    - round3(x: vec3f) -> vec3f
    - round4(x: vec4f) -> vec4f
*/

fn round(x: f32) -> f32 { return sign(x)*floor(abs(x)+0.5); }
fn round2(x: vec2f) -> vec2f { return sign(x)*floor(abs(x)+0.5); }
fn round3(x: vec3f) -> vec3f { return sign(x)*floor(abs(x)+0.5); }
fn round4(x: vec4f) -> vec4f { return sign(x)*floor(abs(x)+0.5); }
