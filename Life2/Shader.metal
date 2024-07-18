//
//  Shader.metal
//  Life2
//
//  Created by Олег Войтин on 07.07.2024.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float4 position [[position]];
    float4 color;
};

struct Uniforms {
    float4x4 transformMatrix;
};

vertex VertexIn vertexShader(uint vertexID [[vertex_id]],
                             constant float2 *vertices [[buffer(0)]],
                             constant float4 *colors [[buffer(1)]],
                             constant Uniforms &uniforms [[buffer(2)]]) {
    VertexIn out;
    float4 pos = float4(vertices[vertexID], 0.0, 1.0);
    out.position = uniforms.transformMatrix * pos;
    out.color = colors[vertexID];
    return out;
}

fragment float4 fragmentShader(VertexIn in [[stage_in]]) {
    return in.color;
}
