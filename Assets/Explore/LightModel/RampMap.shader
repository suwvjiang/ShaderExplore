Shader "Explore/RampMap"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex ("Texture", 2D) = "white" {}
		_RampTex ("RampTex", 2D) = "white" {}
		_Specular("Specular", Color) = (1,1,1,1)
		_Gloss("Gloss", Range(8, 256)) = 16
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" "LightMode"="ForwardBase"}
		LOD 100

		Pass
		{
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
				float3 normal:TEXCOORD3;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _RampTex;
			float4 _RampTex_ST;
			float4 _Color;
			float4 _Specular;
			float _Gloss;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
				o.normal = UnityObjectToWorldNormal(v.normal);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 albedo = tex2D(_MainTex, i.uv);
				
				float3 light = UnityWorldSpaceLightDir(i.worldPos);
				float3 view = UnityWorldSpaceViewDir(i.worldPos);

				float lambert = dot(light, i.normal)*0.5 + 0.5;
				float3 ramp = tex2D(_RampTex, float2(lambert, lambert));
				float3 diffuse = albedo.rgb * ramp.rgb * _Color.rgb * _LightColor0.rgb;

				float3 ambien = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo.rgb;

				float3 h = normalize(light+view);
				float3 specular = _Specular.rgb * _LightColor0.rgb * pow(saturate(dot(h, i.normal)), _Gloss);
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, albedo);
				return fixed4(ambien + diffuse + specular, 1);
			}
			ENDCG
		}
	}
}
