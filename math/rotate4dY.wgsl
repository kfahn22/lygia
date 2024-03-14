/*
contributors: Patricio Gonzalez Vivo
description: returns a 4x4 rotation matrix
use: rotate4dY(r: f32) -> mat4x4<f32>
*/

fn rotate4dY(r: f32) -> mat4x4<f32> {
    return mat4x4<f32>( vec4f(cos(r),0.,-sin(r),0),
                        vec4f(0.,1.,0.,0.),
                        vec4f(sin(r),0.,cos(r),0.),
                        vec4f(0.,0.,0.,1.));
}