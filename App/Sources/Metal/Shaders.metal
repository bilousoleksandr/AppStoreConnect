#include <metal_stdlib>
using namespace metal;

// Vertex structure for fullscreen quad
struct Vertex {
    float2 position;
    float2 texCoord;
};

// Vertex shader output / Fragment shader input
struct VertexOut {
    float4 position [[position]];
    float2 texCoord;
};

// Uniforms for animation
struct Uniforms {
    float time;
    float2 resolution;
};

// Vertex shader for fullscreen effect
vertex VertexOut vertex_main(uint vertexID [[vertex_id]]) {
    // Create fullscreen triangle
    float2 positions[3] = {
        float2(-1.0, -1.0),
        float2( 3.0, -1.0),
        float2(-1.0,  3.0)
    };
    
    float2 texCoords[3] = {
        float2(0.0, 1.0),
        float2(2.0, 1.0),
        float2(0.0, -1.0)
    };
    
    VertexOut out;
    out.position = float4(positions[vertexID], 0.0, 1.0);
    out.texCoord = texCoords[vertexID];
    
    return out;
}

// Fragment shader - animated pattern based on provided code
fragment float4 fragment_main(VertexOut in [[stage_in]],
                             constant Uniforms& uniforms [[buffer(0)]]) {
    float2 r = uniforms.resolution;
    float t = uniforms.time;
    float4 o = float4(0.0);
    
    float2 p = in.texCoord * r / r.y;
    
    for(float i = 0.0, f, g; i < 9.0; i += 1.0) {
        f = sin(i) * i + i;
        g = cos(p / 0.4).x;
        
        float4 cosOffset = cos(p.y + p.x / 0.6 + g + float4(0, 1, 2, 0)) + 1.0;
        float smoothVal = smoothstep(-9.0, 9.0, (0.3 - length(cos(p / 0.3 + t * 0.2))) * r.y / exp(f));
        float expVal = exp(f / 3.0 + sin(i + g + t));
        
        o += cosOffset * smoothVal / expVal * g * g;
        
        p += 1.0 / 0.3;
        
        // Apply rotation matrix
        float2x2 rotMat = float2x2(float2(8, -6), float2(6, 8)) / 9.0;
        p = rotMat * p;
    }
    
    o = sqrt(tanh(0.2 * o));
    
    return float4(o.rgb, 1.0);
}
