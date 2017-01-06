Shader "Explore/HatchingExplore"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_TileFactor("Tile Factor", Float) = 1
		_Outline("Outline", Float) = 0.001
		_Hatch0("Hatch 0", 2D) = "white"{}
		_Hatch1("Hatch 1", 2D) = "white"{}
		_Hatch2("Hatch 2", 2D) = "white"{}
		_Hatch3("Hatch 3", 2D) = "white"{}
		_Hatch4("Hatch 4", 2D) = "white"{}
		_Hatch5("Hatch 5", 2D) = "white"{}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		UsePass "Unity Shaders Book/Chapter 14/Toon Shading/OUTLINE"

		Pass
		{
			Tags { "LightMode"="ForwardBase" }

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fwdbase

			#include "UnityCG.cginc"
			#include "AutoLight.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				fixed3 hatchWeights0:TEXCOORD1;
				fixed3 hatchWeights1:TEXCOORD2;
				float3 worldPos:TEXCOORD3;
				SHADOW_COORDS(4)
			};

			fixed4 _Color;
			float _TileFactor;
			Float _Outline;
			sampler2D _Hatch0; float4 _Hatch0_ST;
			sampler2D _Hatch1; float4 _Hatch1_ST;
			sampler2D _Hatch2; float4 _Hatch2_ST;
			sampler2D _Hatch3; float4 _Hatch3_ST;
			sampler2D _Hatch4; float4 _Hatch4_ST;
			sampler2D _Hatch5; float4 _Hatch5_ST;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.uv * _TileFactor;
				
				o.worldPos = mul(_Object2World, v.vertex).xyz;

				fixed3 worldLightDir = normalize(WorldSpaceLightDir(v.vertex));
				fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);

				fixed diff = dot(worldLightDir, worldNormal) * 0.5 + 0.5;
				//fixed diff = max(0, dot(worldLightDir, worldNormal));
				float hatchFactor = diff * 7;

				o.hatchWeights0 = fixed3(0,0,0);
				o.hatchWeights1 = fixed3(0,0,0);

				if(hatchFactor > 6.0)
				{
					//do nothing
				}
				else if(hatchFactor > 5.0)
				{
					o.hatchWeights0.x = hatchFactor - 5.0;
				}
				else if(hatchFactor > 4.0)
				{
					o.hatchWeights0.x = hatchFactor - 4.0;
					o.hatchWeights0.y = 1 - o.hatchWeights0.x;
				}
				else if(hatchFactor > 3.0)
				{
					o.hatchWeights0.y = hatchFactor - 3.0;
					o.hatchWeights0.z = 1 - o.hatchWeights0.y;
				}
				else if(hatchFactor > 2.0)
				{
					o.hatchWeights0.z = hatchFactor - 2.0;
					o.hatchWeights1.x = 1 - o.hatchWeights0.z;
				}
				else if(hatchFactor > 1.0)
				{
					o.hatchWeights1.x = hatchFactor - 1.0;
					o.hatchWeights1.y = 1 - o.hatchWeights1.x;
				}
				else
				{
					o.hatchWeights1.y = hatchFactor - 1.0;
					o.hatchWeights1.z = 1 - o.hatchWeights1.y;
				}

				TRANSFER_SHADOW(o);

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 hatchTex0 = tex2D(_Hatch0, i.uv) * i.hatchWeights0.x;
				fixed4 hatchTex1 = tex2D(_Hatch1, i.uv) * i.hatchWeights0.y;
				fixed4 hatchTex2 = tex2D(_Hatch2, i.uv) * i.hatchWeights0.z;
				fixed4 hatchTex3 = tex2D(_Hatch3, i.uv) * i.hatchWeights1.x;
				fixed4 hatchTex4 = tex2D(_Hatch4, i.uv) * i.hatchWeights1.y;
				fixed4 hatchTex5 = tex2D(_Hatch5, i.uv) * i.hatchWeights1.z;
				fixed4 white = (1-(i.hatchWeights0.x+i.hatchWeights0.y+i.hatchWeights0.z) - (i.hatchWeights1.x+i.hatchWeights1.y+i.hatchWeights1.z))* fixed4(1,1,1,1);

				fixed4 col = hatchTex0 + hatchTex1 + hatchTex2 + hatchTex3 + hatchTex4 + hatchTex5 + white;
				UNITY_LIGHT_ATTENUATION(atten, i, i.worldPos);
				
				return fixed4 (col.rgb * _Color.rgb * atten, 1);
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
}
