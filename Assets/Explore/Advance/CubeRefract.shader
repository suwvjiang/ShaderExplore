Shader "Explore/CubeRefract"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_CubeMap ("Texture", CUBE) = "" {}
		_RefractColor("Refract Color", Color) = (1,1,1,1)
		_RefractAmount("Refract Amount", Range(0, 1)) = 1
		_RefractRatio("Refract Ratio", Range(0, 1)) = 0.5
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			Tags{ "LightMode"="ForwardBase"}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma mutli_compile_fwdbase
			
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "AutoLight.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal:NORMAL;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float3 worldPos:TEXCOORD0;
				float3 worldNormal:TEXCOORD1;
				float3 worldView:TEXCOORD2;
				float3 worldRefract:TEXCOORD3;
				SHADOW_COORDS(4)
			};

			samplerCUBE _CubeMap;
			float4 _Color;
			float4 _RefractColor;
			float _RefractAmount;
			float _RefractRatio;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
				o.worldNormal = UnityObjectToWorldNormal(v.normal);
				o.worldView = UnityWorldSpaceViewDir(o.worldPos);
				o.worldRefract = refract(-normalize(o.worldView), o.worldNormal, _RefractRatio);
				TRANSFER_SHADOW(o);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed3 normal = normalize(i.worldNormal);
				fixed3 light = normalize(UnityWorldSpaceLightDir(i.worldPos));
				fixed3 view = normalize(i.worldView);

				fixed halfLam = dot(normal, light) * 0.5 + 0.5;
				fixed3 diffuse = _Color * _LightColor0.rgb * halfLam;

				fixed3 h = normalize(view + light);
				fixed temp = saturate(dot(normal, h));
				//fixed3 specular = 

				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

				fixed3 albebo = texCUBE(_CubeMap, i.worldRefract).rgb * _RefractColor.rgb;
				fixed3 col = lerp(diffuse, albebo, _RefractAmount);

				UNITY_LIGHT_ATTENUATION(atten, i, i.worldPos);
				return fixed4(ambient + col * atten, 1);
			}
			ENDCG
		}
	}
}
