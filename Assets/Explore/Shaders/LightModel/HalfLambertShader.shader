Shader "Explore/HalfLambert"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex ("Texture", 2D) = "white" {}
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
				float3 normal:NORMAL;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
				float3 normal:TEXCOORD2;
				float3 worldPos:TEXCOORD3;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			uniform float4 _Color;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.normal = UnityObjectToWorldNormal(v.normal);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 tex = tex2D(_MainTex, i.uv);
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, tex);

				float3 normal = normalize(i.normal);
				float3 light = normalize(UnityWorldSpaceLightDir(i.worldPos));
				float3 diff = tex.rgb * _Color.rgb * _LightColor0.rgb * (dot(normal, light)*0.5+0.5);

				float3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
				
				float3 color = ambient + diff;
				return float4(color, 1);
			}
			ENDCG
		}
	}
}
