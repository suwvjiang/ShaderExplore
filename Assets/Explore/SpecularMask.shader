Shader "Explore/SpecularMask"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex ("Texture", 2D) = "white" {}
		_BumpMap("Bump Map", 2D) = "bump"{}
		_BumpScale("Bump Scale", float) = -1.0
		_SpecularMask("Specular Mask", 2D) = "white"{}
		_SpecularColor("Specular Color", Color) = (1,1,1,1)
		_SpecScale ("Specular Scale", Float) = 0.5
		_Gloss("Gloss", Range(1, 128)) = 8
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
				float4 tangent:TANGENT;
			};

			struct v2f
			{
				float4 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
				float4 t2wx:TEXCOORD2;
				float4 t2wy:TEXCOORD3;
				float4 t2wz:TEXCOORD4;
				float2 uv1:TEXCOORD5;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _BumpMap;
			float4 _BumpMap_ST;
			sampler2D _SpecularMask;
			float4 _SpecularMask_ST;
			float4 _Color;
			float4 _SpecularColor;
			float _BumpScale;
			float _SpecScale;
			float _Gloss;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv.xy = v.uv * _MainTex_ST.xy + _MainTex_ST.zw;
				o.uv.zw = v.uv * _BumpMap_ST.xy + _BumpMap_ST.zw;
				o.uv1 = v.uv * _SpecularMask_ST.xy + _SpecularMask_ST.zw;

				UNITY_TRANSFER_FOG(o,o.vertex);
				float3 worldPos = mul(unity_ObjectToWorld, v.vertex);
				float3 worldTangent = UnityObjectToWorldDir(v.tangent);
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				float3 worldBinormal = cross(worldNormal, worldTangent)*v.tangent.w;
				o.t2wx = float4(worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x);
				o.t2wy = float4(worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y);
				o.t2wz = float4(worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float3 worldPos = float3(i.t2wx.w, i.t2wy.w, i.t2wz.w);
				float3 light = UnityWorldSpaceLightDir(worldPos);
				float3 view = UnityWorldSpaceViewDir(worldPos);

				float3 bump = UnpackNormal(tex2D(_BumpMap, i.uv.zw));
				bump.xy *= _BumpScale;
				bump.z = sqrt(1-dot(bump.xy, bump.xy));
				float3 normal = float3(dot(i.t2wx, bump), dot(i.t2wy, bump), dot(i.t2wz, bump));

				// sample the texture
				fixed4 albedo = tex2D(_MainTex, i.uv.xy);
				//diffuse
				float halflambert = dot(light, normal) * 0.5 + 0.5;
				float3 diffuse = albedo.rgb * _LightColor0.rgb * _Color.rgb * halflambert;
				//specular
				float4 mask = tex2D(_SpecularMask, i.uv1);
				float h = saturate(dot(normal, normalize(view + light)));
				float3 specular = _SpecularColor.rgb * _LightColor0.rgb * pow(h, _Gloss) * mask.r * _SpecScale;
				//ambient
				float3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return fixed4(diffuse + specular + ambient, 1);
			}
			ENDCG
		}
	}
}
