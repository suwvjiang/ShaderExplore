Shader "Explore/3DNoise/Simplex"
{
	Properties
	{
		_Tine("Tine", Color) = (1,1,1,1)
		_MainTex ("Texture", 2D) = "white" {}
		_Scale ("Scale", Range(0.1, 32)) = 1
		_Amount("Amount", Range(0, 1)) = 0.5
		_Ocvate("Ocvate", Range(1, 8)) = 4

		_DissolveRange ("Dissolve Range", Range(0, 0.1)) = 0.01
		_DissolveColor ("Dissolve Color", Color) = (1,1,1,1)
		_DissAddColor("Dissolve Add Color", Color) = (1,1,1,1)
	}
	SubShader
	{
		Tags { "RenderType"="TransparentCutout" "Queue"="AlphaTest"}
		//Tags { "RenderType"="Transparent" "Queue"="Transparent" }
		//Blend SrcAlpha OneMinusSrcAlpha
		LOD 100

		CGINCLUDE
		#include "UnityCG.cginc"
		
		#define MOD3 float3(.1031,.11369,.13787)

		float3 fade(float3 f)
		{
			return f * f * f * (f * (f * 6.0 - 15.0) + 10.0);
		}

		float3 AAndB(float3 a, float3 b)
		{
			return float3(a.x && b.x, a.y && b.y, a.z && b.z);
		}

		float3 AOrB(float3 a, float3 b)
		{
			return float3(a.x || b.x, a.y || b.y, a.z || b.z);
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

		ENDCG

		Pass
		{
			Cull Off
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			struct a2v
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal:NORMAL;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				float3 worldPos:TEXCOORD1;
				float3 normal:TEXCOORD2;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _Tine;
			float4 _DissolveColor;
			float4 _DissAddColor;
			float _Scale;
			float _Amount;
			float _DissolveRange;
			int _Ocvate;
			
			v2f vert (a2v v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
				o.normal = UnityObjectToWorldNormal(v.normal);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float3 light = normalize(UnityWorldSpaceLightDir(i.worldPos));
				float nl = dot(normalize(i.normal), light)*0.5 + 0.5;

				i.worldPos = i.worldPos / _Scale;

				fixed n;
				fixed num;
				fixed freq = 1;
				fixed ampl = 0.5;
				for(int j = 0; j < _Ocvate; ++j)
				{
					n += simplexNoise(i.worldPos, freq) * ampl;
					num += ampl;

					freq *= 2;
					ampl *= 0.5;
				}
				
				n /= num;
				n = n * 0.5 + 0.5;

				float last = n - _Amount;
				clip(last);

				fixed4 color = _Tine * nl;
				if(last <= _DissolveRange)
				{
					color.rgb = lerp(_DissolveColor, _Tine, last/_DissAddColor);
				}
				color *= n;
				return color;
			}
			ENDCG
		}
	}
}
