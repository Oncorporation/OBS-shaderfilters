uniform int shadow_offset_x;
uniform int shadow_offset_y;
uniform int shadow_blur_size;

uniform float4 shadow_color;

uniform bool is_alpha_premultiplied;

float4 mainImage(VertData v_in) : TARGET
{
    int shadow_blur_samples = pow(shadow_blur_size * 2 + 1, 2);
    
    float4 color = image.Sample(textureSampler, v_in.uv);
    float2 shadow_uv = float2(v_in.uv.x - uv_pixel_interval.x * shadow_offset_x, 
                              v_in.uv.y - uv_pixel_interval.y * shadow_offset_y);
    
    float sampled_shadow_alpha = 0;
    
    for (int blur_x = -shadow_blur_size; blur_x <= shadow_blur_size; blur_x++)
    {
        for (int blur_y = -shadow_blur_size; blur_y <= shadow_blur_size; blur_y++)
        {
            float2 blur_uv = shadow_uv + float2(uv_pixel_interval.x * blur_x, uv_pixel_interval.y * blur_y);
            sampled_shadow_alpha += image.Sample(textureSampler, blur_uv).a / shadow_blur_samples;
        }
    }
    
    float4 final_shadow_color = float4(shadow_color.rgb, shadow_color.a * sampled_shadow_alpha);
    
    return final_shadow_color * (1-color.a) + color * (is_alpha_premultiplied * 1 + !is_alpha_premultiplied * color.a);
}
