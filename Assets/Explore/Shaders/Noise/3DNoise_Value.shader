Shader "Explore/3DNoise/Value"
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
					n += valueNoise(i.worldPos, freq) * ampl;
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
