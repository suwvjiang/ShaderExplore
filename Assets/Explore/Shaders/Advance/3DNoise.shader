Shader "Explore/3DNoise"
{
	Properties
	{
		_Tine("Tine", Color) = (1,1,1,1)
		_MainTex ("Texture", 2D) = "white" {}
		_Amount("Amount", Range(0, 1)) = 0.5
		_Ocvate("Ocvate", Range(1, 8)) = 4
	}
	SubShader
	{
		Tags { "RenderType"="TransparentCutout" "Queue"="AlphaTest"}
		//Tags { "RenderType"="Transparent" "Queue"="Transparent" }
		//Blend SrcAlpha OneMinusSrcAlpha
		LOD 100

		CGINCLUDE
		//梯度
		float3 hash(float3 p)
		{
			p = float3(dot(p, float3(127.1, 311.7, 74.7)),
				dot(p, float3(269.5, 183.3, 246.1)),
				dot(p, float3(113.5, 271.9, 124.6)));

			return 2.0 * frac(sin(p) * 43758.5453123) - 1.0;
		}

		float3 fade(float3 f)
		{
			return f * f * f * (f * (f * 6.0 - 15.0) + 10.0);
		}

		float noise(float3 p, float frequency)
		{
			p *= frequency;
			float3 i = floor(p);
			float3 f = frac(p);

			//五次样条线插值
			float3 u = fade(f);

			return lerp(lerp(lerp(dot(hash(fmod(i + float3(0.0, 0.0, 0.0), frequency)), f - float3(0.0, 0.0, 0.0)),
									dot(hash(fmod(i + float3(1.0, 0.0, 0.0), frequency)), f - float3(1.0, 0.0, 0.0)), u.x),
							 lerp(dot(hash(fmod(i + float3(0.0, 1.0, 0.0), frequency)), f - float3(0.0, 1.0, 0.0)),
									dot(hash(fmod(i + float3(1.0, 1.0, 0.0), frequency)), f - float3(1.0, 1.0, 0.0)), u.x), u.y),
						lerp(lerp(dot(hash(fmod(i + float3(0.0, 0.0, 1.0), frequency)), f - float3(0.0, 0.0, 1.0)),
									dot(hash(fmod(i + float3(1.0, 0.0, 1.0), frequency)), f - float3(1.0, 0.0, 1.0)), u.x),
							 lerp(dot(hash(fmod(i + float3(0.0, 1.0, 1.0), frequency)), f - float3(0.0, 1.0, 1.0)),
									dot(hash(fmod(i + float3(1.0, 1.0, 1.0), frequency)), f - float3(1.0, 1.0, 1.0)), u.x), u.y), u.z);
		}

		ENDCG

		Pass
		{
			Cull Off
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
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
				float3 worldPos:TEXCOORD1;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _Tine;
			float _Amount;
			int _Ocvate;
			
			v2f vert (a2v v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed n;
				fixed num;
				fixed freq = 1;
				fixed ampl = 0.5;
				for(int j = 0; j < _Ocvate; ++j)
				{
					n += noise(i.worldPos, freq) * ampl;
					num += ampl;

					freq *= 2;
					ampl *= 0.5;
				}
				n /= num;
				n = n * 0.5 + 0.5;
				clip(n - _Amount);

				fixed4 color = _Tine;
				color *= n;
				return color;
			}
			ENDCG
		}
	}
}
