// Upgrade NOTE: replaced '_LightMatrix0' with 'unity_WorldToLight'
// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/ForwardRendering" 
{
	Properties 
	{
		_Diffuse("Diffuse", Color) = (1,1,1,1)
		_Specular("Specular", Color) = (1,1,1,1)
		_Gloss("Gloss", Range(8.0,256)) = 20
	}
	SubShader 
	{
		Tags { "RenderType"="Opaque" }

		Pass//Base Pass
		{
			Tags {"LightMode"="ForwardBase"}

			CGPROGRAM
			#pragma multi_compile_fwdbase

			#pragma vertex vert
			#pragma fragment frag

			#include "Lighting.cginc"

			fixed4 _Diffuse;
			fixed4 _Specular;
			fixed _Gloss;

			struct a2v
			{
				fixed4 vertex:POSITION;
				fixed4 normal:NORMAL;
			};

			struct v2f
			{
				fixed4 pos:SV_POSITION;
				fixed3 worldNormal:TEXCOORD0;
				fixed4 worldPos:TEXCOORD1;
				fixed4 color:TEXCOORD2;
			};

			v2f vert(a2v v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.worldNormal = mul(v.normal, (float3x3)unity_WorldToObject);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);

				return o;
			}

			fixed4 frag(v2f v):SV_Target
			{
				fixed3 worldNormal = normalize(v.worldNormal);
				fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);

				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

				fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * max(0, dot(worldNormal, worldLightDir));

				fixed3 viewDir = normalize(UnityWorldSpaceViewDir(v.worldPos.xyz));
				fixed3 halfDir = normalize(worldLightDir + viewDir);
				fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0, dot(worldNormal, halfDir)), _Gloss);

				fixed atten = 1.0;
				fixed4 color = fixed4(ambient + (diffuse + specular)*atten, 1.0);

				return color;
			}

			ENDCG
		}

		Pass//Additional Pass
		{
			Tags {"LightMode" = "ForwardAdd"}
			Blend One One

			CGPROGRAM
			#pragma multi_compile_fwdadd

			#pragma vertex vert
			#pragma fragment frag

			#include "Lighting.cginc"
			#include "AutoLight.cginc"

			fixed4 _Diffuse;
			fixed4 _Specular;
			fixed _Gloss;

			struct a2v
			{
				fixed4 vertex:POSITION;
				fixed4 normal:NORMAL;
			};

			struct v2f
			{
				fixed4 pos:SV_POSITION;
				fixed3 worldNormal:TEXCOORD0;
				fixed4 worldPos:TEXCOORD1;
			};

			v2f vert(a2v v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.worldNormal = mul(v.normal, (float3x3)unity_WorldToObject);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
				return o;
			}

			fixed4 frag(v2f v):SV_Target
			{
				fixed3 worldNormal = normalize(v.worldNormal);

				#ifdef USING_DIRECTIONAL_LIGHT
					fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
				#else
					fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz - v.worldPos.xyz);
				#endif

				fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * max(0, dot(worldNormal, worldLightDir));

				fixed3 viewDir = normalize(UnityWorldSpaceViewDir(v.worldPos.xyz));
				fixed3 halfDir = normalize(worldLightDir + viewDir);
				fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0, dot(worldNormal, halfDir)), _Gloss);

				#ifdef USING_DIRECTIONAL_LIGHT
					fixed atten = 1.0;
				#else
					float3 lightCoord = mul(unity_WorldToLight, v.worldPos).xyz;
					fixed atten = tex2D(_LightTexture0, dot(lightCoord, lightCoord).rr).UNITY_ATTEN_CHANNEL;
				#endif

				return fixed4((diffuse + specular)*atten, 1.0);
			}

			ENDCG
		}
	} 
	FallBack "Diffuse"
}
