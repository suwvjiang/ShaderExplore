Shader "Explore/CubeReflect"
{
	Properties
	{
		_Color ("Color", Color)=(1,1,1,1)
		_CubeMap("Cube Map", Cube) = "_skybox"{}
		_ReflectColor ("Reflect Color", Color)=(1,1,1,1)
		_ReflectAmount("Reflect Amount", Range(0, 1)) = 0.5
		_SpecularColor("Specular Color", Color) = (1,1,1,1)
		_Gloss("Gloss", Range(1, 64)) = 16
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			Tags {"LightMode"="ForwardBase"}

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fwdbase
			
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
				float2 uv : TEXCOORD0;
				float3 worldNormal:TEXCOORD1;
				float3 reflect:TEXCOORD2;
				float3 worldPos:TEXCOORD3;
				float3 worldView:TEXCOORD4;
				SHADOW_COORDS(5)
			};

			samplerCUBE _CubeMap;
			fixed4 _Color;
			fixed4 _ReflectColor;
			fixed4 _SpecularColor;
			fixed _ReflectAmount;
			fixed _Gloss;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.worldNormal = UnityObjectToWorldNormal(v.normal);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
				o.worldView = normalize(UnityWorldSpaceViewDir(o.worldPos));
				o.reflect = reflect(-o.worldView, o.worldNormal);
				TRANSFER_SHADOW(o);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float3 normal = normalize(i.worldNormal);
				float3 light = normalize(UnityWorldSpaceLightDir(i.worldPos));

				// sample the texture
				fixed3 albedo = texCUBE(_CubeMap, i.reflect).rgb * _ReflectColor.rgb;

				float3 halfLam = dot(normal, light) * 0.5 + 0.5;
				fixed3 diffuse = _Color.rgb * _LightColor0.rgb + halfLam;

				fixed3 h = normalize(i.worldView + light);
				fixed temp = saturate(dot(normal, h));
				fixed3 specular = _SpecularColor.rgb * _LightColor0.rgb * pow(temp, _Gloss);

				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo.rgb;

				UNITY_LIGHT_ATTENUATION(atten, i, i.worldPos);

				fixed3 col = lerp(diffuse, albedo, _ReflectAmount);

				return fixed4(ambient + (col + specular)*atten, 1);
			}
			ENDCG
		}
	}
	FallBack "Specular"
}
