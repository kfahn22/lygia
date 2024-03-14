/*
contributors: Patricio Gonzalez Vivo
description: gaussian coeficient
use: 
    - gaussian(d: f32, sigma: f32) -> f32
    - gaussian2(d: vec2f, sigma: f32) -> f32
    - gaussian3(d: vec3f, sigma: f32) -> f32
    - gaussian4(d: vec4f, sigma: f32) -> f32
examples:
    - https://raw.githubusercontent.com/patriciogonzalezvivo/lygia_examples/main/math_gaussian.frag
*/

fn gaussian(d: f32, sigma: f32) -> f32 { return exp(-(d*d) / (2.0 * sigma * sigma)); }
fn gaussian2(d: vec2f, sigma: f32) -> f32 { return exp(-(d.x*d.x + d.y*d.y) / (2.0 * sigma * sigma));  }
fn gaussian3(d: vec3f, sigma: f32) -> f32 { return exp(-(d.x*d.x + d.y*d.y + d.z*d.z) / (2.0 * sigma * sigma)); }
fn gaussian4(d: vec4f, sigma: f32) -> f32 { return exp(-(d.x*d.x + d.y*d.y + d.z*d.z + d.w*d.w) / (2.0 * sigma * sigma)); }