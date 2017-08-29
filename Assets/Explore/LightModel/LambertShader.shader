Shader "Explore/Lambert"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Albedo", 2D) = "white"{}
	}

	SubShader
	{
		Tags { "RenderType"="Opaque"}

		Pass
		{
			Tags {"LightMode"="ForwardBase"}
			CGPROGRAM
			#pragma multi_compile_fwdbase
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			struct a2v
			{
				float4 vertex : POSITION;
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
			fixed4 _Color;


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
				fixed4 albedo = tex2D(_MainTex, i.uv);

				half3 normal = normalize(i.worldNormal);
				half3 light = UnityWorldSpaceLightDir(i.worldPos);
				half lambert = saturate(dot(light, normal));

				fixed3 diffuse = albedo.rgb * _LightColor0.rgb * _Color.rgb * lambert;

				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo.rgb;

				return fixed4(diffuse + ambient, 1);
			}
			ENDCG
		}
	}
	FallBack Off
}