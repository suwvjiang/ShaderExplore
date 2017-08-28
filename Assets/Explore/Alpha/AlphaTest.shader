﻿Shader "Explore/AlphaTest"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex ("Texture", 2D) = "white" {}
		_Clip("Clip", Range(0,1)) = 0.5
	}
	SubShader
	{
		Tags { "RenderType"="TransparentCutout" "Queue"="AlphaTest"}
		LOD 100

		Pass
		{
			Tags{"LightMode"="ForwardBase"}
			Cull Off
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal:NORMAL;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
				float3 worldPos:TEXCOORD2;
				float3 worldNormal:TEXCOORD3;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _Color;
			float _Clip;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
				o.worldNormal = UnityObjectToWorldNormal(v.normal);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 albedo = tex2D(_MainTex, i.uv);
				clip(albedo.a - _Clip);
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, albedo);
				float3 normal = normalize(i.worldNormal);
				float3 light = normalize(UnityWorldSpaceLightDir(i.worldPos));
				float halflambert = dot(light, normal) * 0.5 + 0.5;
				float3 diffuse = albedo.rgb * _LightColor0.rgb * _Color.rgb * halflambert;

				float3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;

				return fixed4(diffuse + ambient, 1);
			}
			ENDCG
		}
	}
	Fallback "Transparent/Cutout/VertexLit"
}
