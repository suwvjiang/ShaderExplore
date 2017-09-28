Shader "Explore/Clound"
{
	Properties
	{
		_MainTex("Main Tex", 2D) = ""{}
		_CloundScale("Clound Scale", Range(0, 2)) = 1.1
		_Speed("Speed", Float) = 1
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100
		CGINCLUDE
		#define K1 0.366025404
		#define K2 0.211324865
		//#define M {1.6, 1.2, -1.2, 1.6}

		half2 hash(half2 p) 
		{
			p = half2(dot(p, half2(127.1,311.7)), dot(p, half2(269.5,183.3)));
			return -1.0 + 2.0 * frac(sin(p)*43758.5453123);
		}

		float noise(float2 p) 
		{
			float2 i = floor(p + (p.x + p.y) * K1);
			float2 a = p - i + (i.x+i.y) * K2;
			float2 o = (a.x > a.y) ? float2(1.0,0.0) : float2(0.0,1.0); //vec2 of = 0.5 + 0.5*vec2(sign(a.x-a.y), sign(a.y-a.x));
			float2 b = a - o + K2;
			float2 c = a - 1.0 + 2.0 * K2;
			float2 h = max(0.5 - float3(dot(a,a), dot(b,b), dot(c,c)), 0.0 );
			float2 n = h * h * h * h * float3( dot(a, hash(i + 0.0)), dot(b, hash(i + o)), dot(c,hash(i + 1.0)));
			return dot(n, 70.0);	
		}

		float fbm(float2 p)
		{
			const float2x2 M = {1.6, 1.2, -1.2, 1.6};
			float total = 0;
			float ampl = 0.1;
			for(int i = 0; i < 7; ++i)
			{
				total += noise(p) * ampl;
				p = mul(M, p);
				ampl *= 0.4;
			}
			return total;
		}

		ENDCG
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
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
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _CloundScale;
			float _Speed;
			
			v2f vert (a2v v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float t = _Time.y * _Speed;
				float q = fbm(i.uv * _CloundScale * 0.5);

				float r = 0;
				float2 uv1 = i.uv * _CloundScale;
				uv1 -= q - t;
				return 0;
			}
			ENDCG
		}
	}
}
