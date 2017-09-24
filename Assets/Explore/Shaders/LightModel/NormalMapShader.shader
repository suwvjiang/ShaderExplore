Shader "Explore/NormalMap"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex ("Texture", 2D) = "white" {}
		_NormalTex("Normal Texture", 2D) = "bump"{}
		_NormalScale("Normal Scale", float) = 1
		_Specular("Specular", Color) = (1, 1, 1, 1)
		_Gloss("Gloss", Range(8,256)) = 50
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
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float4 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 t2wx:TEXCOORD2;
				float4 t2wy:TEXCOORD3;
				float4 t2wz:TEXCOORD4;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _NormalTex;
			float4 _NormalTex_ST;
			float4 _Color;
			float _NormalScale;
			float4 _Specular;
			float _Gloss;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv.xy = v.uv * _MainTex_ST.xy + _MainTex_ST.zw;
				o.uv.zw = v.uv * _NormalTex_ST.xy + _NormalTex_ST.zw;
				UNITY_TRANSFER_FOG(o,o.vertex);

				float3 worldPos = mul(unity_ObjectToWorld, v.vertex);
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				float3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
				float3 worldBinormal = cross(worldNormal, worldTangent.xyz) * v.tangent.w;
				
				o.t2wx = float4(worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x);
				o.t2wy = float4(worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y);
				o.t2wz = float4(worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed3 worldPos = fixed3(i.t2wx.w, i.t2wy.w, i.t2wz.w);
				float3 light = normalize(UnityWorldSpaceLightDir(worldPos));
				float3 viewDir = normalize(UnityWorldSpaceViewDir(worldPos));

				float3x3 t2w = float3x3(i.t2wx.xyz, i.t2wy.xyz, i.t2wz.xyz);
				float3 temp = UnpackNormal(tex2D(_NormalTex, i.uv.zw));
				temp.xy *= _NormalScale;
				temp.z = sqrt(1.0 - saturate(dot(temp.xy, temp.xy)));
				float3 normal = normalize(mul(t2w, temp));

				//diffuse
				fixed3 albedo = tex2D(_MainTex, i.uv).rgb * _Color.rgb;
				float lambert = dot(light, normal) * 0.5 + 0.5;
				fixed3 diff = albedo * _LightColor0.rgb * lambert;

				//ambient
				float3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;

				//specular
				float3 h = normalize(viewDir + light);
				float3 specular = _Specular.rgb * _LightColor0.rgb * pow(saturate(dot(h, normal)), _Gloss);
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);

				return fixed4(diff+ambient+specular, 1);
			}
			ENDCG
		}
	}
}
