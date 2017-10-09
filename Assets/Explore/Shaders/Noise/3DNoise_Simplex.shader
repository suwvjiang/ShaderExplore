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
		#include "../../CgIncludes/NoiseCG.cginc"
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
				fixed n = simplexFBM(i.worldPos, _Ocvate, 1, 2, 0.5, 0.5);
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
