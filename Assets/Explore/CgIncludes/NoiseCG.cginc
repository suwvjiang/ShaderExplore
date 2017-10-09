#ifndef NoiseCG
#define NoiseCG
#endif
			
#define MOD3 float3(.1031,.11369,.13787)

float3 fade(float3 f)
{
	return f * f * f * (f * (f * 6.0 - 15.0) + 10.0);
}

//梯度
float3 hashOld(float3 p)
{
	p = float3(dot(p, float3(127.1, 311.7, 74.7)),
				dot(p, float3(269.5, 183.3, 246.1)),
				dot(p, float3(113.5, 271.9, 124.6)));

	return - 1.0 + 2.0 * frac(sin(p) * 43758.5453123);
}

float3 hash(float3 p)
{
	p = frac(p * MOD3);
	p += dot(p, p.yxz+19.19);
	return -1.0 + 2.0 * frac(float3((p.x + p.y)*p.z, (p.x+p.z)*p.y, (p.y+p.z)*p.x));
}

float perlinNoise(float3 p, float frequency)
{
	p *= frequency;
	float3 i = floor(p);
	float3 f = frac(p);
	//五次样条线插值
	float3 u = fade(f);

	return lerp(lerp(lerp(dot(hash(i), f),
							dot(hash(i + float3(1.0, 0.0, 0.0)), f - float3(1.0, 0.0, 0.0)), u.x),
						lerp(dot(hash(i + float3(0.0, 1.0, 0.0)), f - float3(0.0, 1.0, 0.0)),
							dot(hash(i + float3(1.0, 1.0, 0.0)), f - float3(1.0, 1.0, 0.0)), u.x), u.y),
				lerp(lerp(dot(hash(i + float3(0.0, 0.0, 1.0)), f - float3(0.0, 0.0, 1.0)),
							dot(hash(i + float3(1.0, 0.0, 1.0)), f - float3(1.0, 0.0, 1.0)), u.x),
						lerp(dot(hash(i + float3(0.0, 1.0, 1.0)), f - float3(0.0, 1.0, 1.0)),
							dot(hash(i + float3(1.0, 1.0, 1.0)), f - float3(1.0, 1.0, 1.0)), u.x), u.y), u.z);
}

float perlinFBM(float3 p, int ocvate, float originFreq, float frequency, float originAmpl, float amplitude)
{
	float total = 0;
	float num = 0;
	float freq = originFreq;
	float ampl = originAmpl;
	for(int i = 0; i < ocvate; ++i)
	{
		total += perlinNoise(p, freq) * ampl;
		num += ampl;
		freq *= frequency;
		ampl *= amplitude;
	}
	return total / num;
}

float valueHashOld(float3 p)
{
	float h = dot(p,float3(127.1,311.7, 74.7));
	
	return -1.0 + 2.0 * frac(sin(h)*43758.5453123);
}

float valueHash(float3 p)
{
	p  = frac(p * MOD3);
	p += dot(p, p.yzx + 19.19);
	return - 1.0 + 2.0 * frac((p.x + p.y) * p.z);
}

float valueNoise(float3 p, float frequency)
{
	p *= frequency;
	float3 i = floor(p);
	float3 f = frac(p);

	float3 u = fade(f);

	return lerp(lerp(lerp(valueHash(i + float3(0.0, 0.0, 0.0)), valueHash(i + float3(1.0, 0.0, 0.0)), u.x),
						lerp(valueHash(i + float3(0.0, 1.0, 0.0)), valueHash(i + float3(1.0, 1.0, 0.0)), u.x), u.y), 
				lerp(lerp(valueHash(i + float3(0.0, 0.0, 1.0)), valueHash(i + float3(1.0, 0.0, 1.0)), u.x),
						lerp(valueHash(i + float3(0.0, 1.0, 1.0)), valueHash(i + float3(1.0, 1.0, 1.0)), u.x), u.y), u.z);
}

float valueFBM(float3 p, int ocvate, float originFreq, float frequency, float originAmpl, float amplitude)
{
	float total = 0;
	float num = 0;
	float freq = originFreq;
	float ampl = originAmpl;
	for(int i = 0; i < ocvate; ++i)
	{
		total += valueNoise(p, freq) * ampl;
		num += ampl;
		freq *= frequency;
		ampl *= amplitude;
	}
	return total / num;
}

float3 AAndB(float3 a, float3 b)
{
	return float3(a.x && b.x, a.y && b.y, a.z && b.z);
}

float3 AOrB(float3 a, float3 b)
{
	return float3(a.x || b.x, a.y || b.y, a.z || b.z);
}

float simplexNoise(float3 p, float frequency)
{
	const float K1 = 0.333333333;
	const float K2 = 0.166666667;

	p *= frequency;

	float3 i = floor(p + (p.x + p.y + p.z) * K1);
	float3 d0 = p - (i - (i.x + i.y + i.z) * K2);
	
	float3 e1 = step(0.0, d0 - d0.yzx);
	float3 e2 = step(0.0, d0 - d0.zxy);
	float3 i1 = AAndB(e1, e2);
	float3 i2 = AOrB(e1, e2);
	
	float3 d1 = d0 - (i1 - 1.0 * K2);
	float3 d2 = d0 - (i2 - 2.0 * K2);
	float3 d3 = d0 - (1.0 - 3.0 * K2);
	
	float4 h = max(0.6 - float4(dot(d0, d0), dot(d1, d1), dot(d2, d2), dot(d3, d3)), 0.0);
	float4 n = h * h * h * h * float4(dot(d0, hash(i)), dot(d1, hash(i + i1)), dot(d2, hash(i + i2)), dot(d3, hash(i + 1.0)));
	
	return dot(31.316, n);
}

float simplexFBM(float3 p, int ocvate, float originFreq, float frequency, float originAmpl, float amplitude)
{
	float total = 0;
	float num = 0;
	float freq = originFreq;
	float ampl = originAmpl;
	for(int i = 0; i < ocvate; ++i)
	{
		total += simplexNoise(p, freq) * ampl;
		num += ampl;
		freq *= frequency;
		ampl *= amplitude;
	}
	return total / num;
}

