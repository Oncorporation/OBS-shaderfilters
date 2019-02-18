uniform int glow_percent = 10;
uniform int blur = 1;
uniform int min_brightness= 27;
uniform int max_brightness = 100;
uniform int pulse_speed = 0;

float4 mainImage(VertData v_in) : TARGET
{
	const float2 offsets[4] = 
	{
		-0.1,  0.125,
		-0.1, -0.125,
		0.1, -0.125,
		0.1,  0.125
	};

	// convert input for vector math
	float4 color = image.Sample(textureSampler, v_in.uv);
	float blur_amount = (float)blur /100;
	float glow_amount = (float)glow_percent / 100;
	float speed = (float)pulse_speed / 100;	
	float luminance_floor = float(min_brightness) /100;
	float luminance_ceiling = float(max_brightness) /100;

	float t = elapsed_time * speed;

	// simple glow calc
	for (int n = 0; n < 4; n++){
		float4 ncolor = image.Sample(textureSampler, v_in.uv + (blur_amount * (1 + sin(t)) ) * offsets[n]);
		float intensity = dot(ncolor * 1 ,float3(0.299,0.587,0.114));
		if ((intensity >= luminance_floor) && (intensity <= luminance_ceiling))
		{
			ncolor.a = clamp(ncolor.a * glow_amount, 0.0, 1.0);
			color += (ncolor * (glow_amount * (1 + sin(t))) );
		}
	}

	return color;

}
