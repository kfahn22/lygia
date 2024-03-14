/*
contributors: Patricio Gonzalez Vivo
description: returns a 2x2 rotation matrix
use: rotate2d(r: f32) -> mat2x2<f32>
*/

fn rotate2d(radians: f32) -> mat2x2<f32> {
    let c = cos(radians);
    let s = sin(radians);
    return mat2x2<f32>(c, -s, s, c);
}
