Shader "Explore/Shadow"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex ("Texture", 2D) = "white" {}
		_BumpMap("Bump Map", 2D) = "bump"{}
		_BumpScale("Bump Scale", Float) = 0.5
		_Specular("Specular", 2D) = "white"{}
		_SpecularColor("Specular Color", Color) = (1,1,1,1)
		_SpecScale("Specular Scale", Range(0, 1)) = 0.5
		_Gloss("Gloss", Range(1, 64)) = 8
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
			
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "AutoLight.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal:NORMAL;
				float4 tangent:TANGENT;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float4 uv : TEXCOORD0;
				float4 t2wx:TEXCOORD1;
				float4 t2wy:TEXCOORD2;
				float4 t2wz:TEXCOORD3;
				float2 uv1:TEXCOORD4;
				SHADOW_COORDS(5)
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _BumpMap;
			float4 _BumpMap_ST;
			sampler2D _Specular;
			float4 _Specular_ST;
			float4 _Color;
			float4 _SpecularColor;
			float _BumpScale;
			float _SpecScale;
			float _Gloss;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv.xy = v.uv*_MainTex_ST.xy + _MainTex_ST.zw;
				o.uv.zw = v.uv*_BumpMap_ST.xy + _BumpMap_ST.zw;
				o.uv1.xy = v.uv*_Specular_ST.xy + _Specular_ST.zw;

				float3 worldPos = mul(unity_ObjectToWorld, v.vertex);
				float3 worldTan = UnityObjectToWorldDir(v.tangent);
				float3 worldNor = UnityObjectToWorldNormal(v.normal);
				float3 worldBin = cross(worldNor, worldTan).xyz * v.tangent.w;

				o.t2wx = float4(worldTan.x, worldBin.x, worldNor.x, worldPos.x);
				o.t2wy = float4(worldTan.y, worldBin.y, worldNor.y, worldPos.y);
				o.t2wz = float4(worldTan.z, worldBin.z, worldNor.z, worldPos.z);

				TRANSFER_SHADOW(o);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float3 worldPos = float3(i.t2wx.w, i.t2wy.w, i.t2wz.w);
				fixed3 light = normalize(UnityWorldSpaceLightDir(worldPos));
				fixed3 view = normalize(UnityWorldSpaceViewDir(worldPos));

				// sample the texture
				fixed4 albedo = tex2D(_MainTex, i.uv.xy);
				fixed3 bump = UnpackNormal(tex2D(_BumpMap, i.uv.zw));
				bump.xy *= _BumpScale;
				bump.z = sqrt(1-max(0, dot(bump.xy, bump.xy)));

				fixed3 normal = fixed3(dot(i.t2wx, bump), dot(i.t2wy, bump), dot(i.t2wz, bump));
				//normal = normalize(normal);

				half halfLam = dot(light, normal) * 0.5 + 0.5;
				fixed3 diffuse = albedo.rgb * _LightColor0.rgb * _Color.rgb * halfLam;

				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo.rgb;

				fixed3 h = normalize(view + light);
				fixed temp = saturate(dot(h, normal));
				fixed4 mask = tex2D(_Specular, i.uv1);
				fixed3 specular = _SpecularColor.rgb * _LightColor0.rgb * pow(temp, _Gloss) * _SpecScale * mask.r ;

				fixed shadow = SHADOW_ATTENUATION(i);
				fixed atten = 1.0;

				return fixed4(ambient + (diffuse + specular) * atten * shadow, 1);
			}
			ENDCG
		}
	}
	Fallback "Specular"
}
