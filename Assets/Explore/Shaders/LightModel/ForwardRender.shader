Shader "Explore/ForwardRender"
{
	Properties
	{
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Texture", 2D) = "white" {}
		_SpecularColor ("Specular Color", Color) = (1,1,1,1)
		_Gloss ("Gloss", Range(8, 128)) = 8
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

			#pragma multi_compile_fwdbase
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
			fixed4 _Color;
			fixed4 _SpecularColor;
			float _Gloss;
			
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
				fixed3 albedo = tex2D(_MainTex, i.uv).rgb;
				fixed3 normal = normalize(i.worldNormal);
				fixed3 light = normalize(UnityWorldSpaceLightDir(i.worldPos));
				fixed3 view = normalize(UnityWorldSpaceViewDir(i.worldPos));
				fixed3 h = normalize(view + light);

				fixed halfLambert = dot(normal, light) * 0.5 + 0.5;
				fixed blinn = saturate(dot(normal, h));

				fixed3 diffuse = albedo.rgb * _LightColor0.rgb * _Color.rgb * halfLambert;

				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo.rgb;

				fixed3 specular = _SpecularColor.rgb * _LightColor0.rgb * pow(blinn, _Gloss);

				fixed atten = 1;
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return fixed4(ambient + (diffuse +  specular)*atten, 1);
			}
			ENDCG
		}

		Pass
		{
			Tags {"LightMode"="ForwardAdd"}
			Blend One One

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fwdadd

			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "AutoLight.cginc"

			struct a2v
			{
				float4 vertex:POSITION;
				float2 uv:TEXCOORD0;
				float3 normal:NORMAL;
			};

			struct v2f
			{
				float4 pos:SV_POSITION;
				float2 uv:TEXCOORD0;
				float3 worldPos:TEXCOORD1;
				float3 worldNormal:TEXCOORD2;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _Color;
			float4 _SpecularColor;
			float _Gloss;

			v2f vert(a2v v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
				o.worldNormal = UnityObjectToWorldNormal(v.normal);

				return o;
			}

			fixed4 frag(v2f i):SV_Target
			{
				fixed3 albedo = tex2D(_MainTex, i.uv).rgb;

				fixed3 normal = normalize(i.worldNormal);
				fixed3 light = normalize(UnityWorldSpaceLightDir(i.worldPos));
				fixed3 view = normalize(UnityWorldSpaceViewDir(i.worldPos));
				fixed3 h = normalize(view + light);

				fixed halfLambert = dot(normal, light) * 0.5 + 0.5;
				fixed blinn = saturate(dot(normal, h));

				fixed3 diffuse = albedo.rgb * _LightColor0.rgb * _Color.rgb * halfLambert;

				fixed3 specular = _SpecularColor.rgb * _LightColor0.rgb * pow(blinn, _Gloss);

				#ifdef USING_DIRECTIONAL_LIGHT
					fixed atten = 1.0;
				#else
					float3 lightCoord = mul(unity_WorldToLight, float4(i.worldPos, 1)).xyz;
					fixed atten = tex2D(_LightTexture0, dot(lightCoord, lightCoord).rr).UNITY_ATTEN_CHANNEL;
				#endif

				return fixed4((diffuse + specular)*atten, 1);
			}

			ENDCG
		}
	}
	Fallback "Specular"
}
