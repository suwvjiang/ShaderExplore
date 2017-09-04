Shader "Explore/Fresnel"
{
	Properties
	{
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Texture", CUBE) = "" {}
		_Fresnel("Fresnel", Range(0,1)) = 1
	}
	SubShader
	{
		Tags {"RenderType"="Opaque"}
		Pass
		{
			Tags {"LightMode"="ForwardBase"}

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
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
				float3 worldPos:TEXCOORD1;
				float3 worldNormal:TEXCOORD2;
				float3 worldView:TEXCOORD3;
				float3 worldRef : TEXCOORD4;
			};

			samplerCUBE _MainTex;
			fixed4 _Color;
			fixed _Fresnel;

			v2f vert (appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
				o.worldNormal = UnityObjectToWorldNormal(v.normal);
				o.worldView = normalize(UnityWorldSpaceViewDir(o.worldPos));
				o.worldRef = reflect(-o.worldView, o.worldNormal);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed3 light = normalize(UnityWorldSpaceLightDir(i.worldPos));
				fixed3 normal = normalize(i.worldNormal);
				fixed3 view = normalize(i.worldView);

				fixed halfLam = dot(normal, light) * 0.5 + 0.5;
				fixed NdotV = dot(normal, view);
				fixed fresnel = _Fresnel + (1-_Fresnel)*pow(1-NdotV, 5);

				fixed3 reflect = texCUBE(_MainTex, i.worldRef).rgb * _Color.rgb;

				fixed3 diffuse = _Color.rgb * _LightColor0.rgb * halfLam;

				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

				fixed3 col = lerp(diffuse, reflect, fresnel);

				return fixed4(ambient + col, 1);
			}
			ENDCG
		}
	}
}
