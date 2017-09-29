Shader "Explore/Cloud"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Main Tex", 2D) = ""{}
		_CloudScale("Clound Scale", Range(0, 5)) = 1.5
		_Speed("Speed", Range(0, 1)) = 1
		_CloudDark("Cloud Dark", Range(0, 1)) = 0.5
		_CloudLight("Cloud Light", Range(0, 1)) = 0.3
		_CloudAlpha("Cloud Alpha", Float) = 8
		_CloudCover("Cloud Cover", Range(0, 1)) = 0.2
		_SkyTint("Sky Tint", Float) = 0.5
		_SkyColor1("Sky Color 1", Color) = (0.2, 0.6, 0.6, 1)
		_SkyColor2("Sky Color 2", Color) = (0.4, 0.7, 1, 1)
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100
		CGINCLUDE
    	#include "UnityCG.cginc"

		#define K1 0.366025404
		#define K2 0.211324865
		//#define M {1.6, 1.2, -1.2, 1.6}

		const float2x2 M = {1.6, 1.2, -1.2, 1.6};

		half2 hash(half2 p)
		{
			p = half2(dot(p, half2(127.1,311.7)), dot(p, half2(269.5,183.3)));
			return -1.0 + 2.0 * frac(sin(p)*43758.5453123);
		}

		float noise(float2 p) 
		{
			float2 i = floor(p + (p.x + p.y) * K1);
			float2 a = p - i + (i.x+i.y) * K2;
			float2 o = (a.x > a.y) ? float2(1.0, 0.0) : float2(0.0, 1.0); //vec2 of = 0.5 + 0.5*vec2(sign(a.x-a.y), sign(a.y-a.x));
			float2 b = a - o + K2;
			float2 c = a - 1.0 + 2.0 * K2;
			float3 h = max(0.5 - float3(dot(a,a), dot(b,b), dot(c,c)), 0.0 );
			float3 n = h * h * h * h * float3(dot(a, hash(i)), dot(b, hash(i + o)), dot(c,hash(i + 1.0)));
			return dot(n, 70.0);	
		}

		float fbm(float2 p, float ocvate, float2 offset, float amplStart, float amplScale)
		{
			float total = 0;
			float ampl = amplStart;
			for(int i = 0; i < ocvate; ++i)
			{
				total += noise(p) * ampl;
				p = 2 * p + offset;
				ampl *= amplScale;
			}
			return total;
		}

		float fbmabs(float2 p, float ocvate, float2 offset, float amplStart, float amplScale)
		{
			float total = 0;
			float ampl = amplStart;
			for(int i = 0; i < ocvate; ++i)
			{
				total += abs(noise(p)) * ampl;
				p = 2 * p + offset;
				ampl *= amplScale;
			}
			return total;
		}

		ENDCG
		Pass
		{
			ZTest Always ZWrite Off Cull Off

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			
			#include "UnityCG.cginc"

			struct a2v
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				float4 srcPos:TEXCOORD1;
			};

			sampler2D _MainTex;
			float4 _MainTex_TexelSize;
			float4 _Color;
			float4 _SkyColor1;
			float4 _SkyColor2;
			float _CloudScale;
			float _Speed;
			float _CloudDark;
			float _CloudLight;
			float _CloudAlpha;
			float _CloudCover;
			float _SkyTint;
			
			v2f vert (a2v v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				o.srcPos = ComputeScreenPos(v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float t = _Time.x * _Speed;
				float q = 0;//fbm(i.uv * _CloudScale * 0.5, 7, 0, 0.1, 0.4);

				float2 uv1 = i.uv * _CloudScale;
				uv1 += t - q;
				float r = fbmabs(uv1, 8, t, 0.8, 0.7);

				float2 uv2 = i.uv * _CloudScale;
				uv2 += t - q;
				float f = fbm(uv2, 8, t, 0.7, 0.6);

				f *= r + f;

				float t2 = _Time.x * _Speed * 2;
				float2 uv3 = i.uv * _CloudScale * 2;
				uv3 += t2 - q;
				float c = fbm(uv3, 7, t2, 0.4, 0.6);

				float t3 = _Time.x * _Speed * 3;
				float2 uv4 = i.uv * _CloudScale * 3;
				uv4 += t3 - q;
				float c1 = fbmabs(uv3, 7, t3, 0.4, 0.6);

				float color = c + c1;

				fixed3 sky = lerp(_SkyColor2, _SkyColor1, i.uv.y);
				fixed3 cloud = fixed3(1.1, 1.1, 0.9) * clamp((_CloudDark + _CloudLight * color), 0, 1);

				f = _CloudCover + _CloudAlpha * f * r;
				fixed3 result = lerp(sky, clamp(_SkyTint * sky + cloud, 0, 1), clamp(f + color, 0, 1));

				return fixed4(result , 1);
			}
			ENDCG
		}
	}
}
