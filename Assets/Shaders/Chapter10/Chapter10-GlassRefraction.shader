Shader "Explore/GlassRefraction"
{
	Properties
	{
		_Color("Color",Color) = (1,1,1,1)
		_MainTex("MainTex", 2D) = "white"{}
		_BumpMap("Normal Map", 2D) ="bump"{}
		_CubeMap("Cube Map", Cube) = ""{}
		_BumpScale("Bump Scale", Float) = -1
		_Distortion("Distortion", Range(0, 100)) = 10
		_RefractAmount("Refract Amount", Range(0, 1)) = 0.5
	}

	SubShader
	{
		Tags {"Queue"="Transparent" "RenderType"="Opaque"}

		GrabPass {"_RenderTexure"}

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "AutoLight.cginc"

			struct a2v
			{
				float4 vertex:POSITION;
				float2 texcoord:TEXCOORD0;
				float3 normal:NORMAL;
				float4 tangent:TANGENT;
			};

			struct v2f
			{
				float4 pos:SV_POSITION;
				float4 uv:TEXCOORD0;
				float4 srcPos:TEXCOORD1;
				float4 t2wx:TEXCOORD2;
				float4 t2wy:TEXCOORD3;
				float4 t2wz:TEXCOORD4;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _BumpMap;
			float4 _BumpMap_ST;
			samplerCUBE _CubeMap;
			sampler2D _RenderTexure;
			float4 _RenderTexure_TexelSize;
			float4 _Color;
			float _Distortion;
			float _BumpScale;
			float _RefractAmount;

			v2f vert(a2v v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.uv.zw = TRANSFORM_TEX(v.texcoord, _BumpMap);
				float3 worldPos = mul(unity_ObjectToWorld, v.vertex);
				float3 worldNomal = UnityObjectToWorldNormal(v.normal);
				float3 worldTangent = UnityObjectToWorldDir(v.tangent);
				float3 worldBin = cross(worldNomal, worldTangent) * v.tangent.w;

				o.t2wx = float4(worldTangent.x, worldBin.x, worldNomal.x, worldPos.x);
				o.t2wy = float4(worldTangent.y, worldBin.y, worldNomal.y, worldPos.y);
				o.t2wz = float4(worldTangent.z, worldBin.z, worldNomal.z, worldPos.z);

				o.srcPos = ComputeGrabScreenPos(o.pos);
				return o;
			}

			fixed4 frag(v2f i):SV_Target
			{
				fixed3 worldPos = fixed3(i.t2wx.w, i.t2wy.w, i.t2wz.w);
				float3 view = normalize(UnityWorldSpaceViewDir(worldPos));
				
				fixed3 bump = UnpackNormal(tex2D(_BumpMap, i.uv.zw));
				bump.xy *= _BumpScale;
				bump.z = sqrt(1-dot(bump.xy, bump.xy));
				fixed3 normal = fixed3(dot(i.t2wx.xyz, bump), dot(i.t2wy.xyz, bump), dot(i.t2wz.xyz, bump));

				float2 offset = bump.xy * _Distortion * _RenderTexure_TexelSize.xy;
				i.srcPos.xy = offset + i.srcPos.xy;
				fixed4 refractColor = tex2D(_RenderTexure, i.srcPos.xy/i.srcPos.w);

				fixed3 albedo = tex2D(_MainTex, i.uv.xy).rgb;
				fixed3 refDir = reflect(-view, normal);
				fixed3 refColor = texCUBE(_CubeMap, refDir).xyz;// * albedo.rgb;

				fixed3 col = lerp(refractColor, refColor, _RefractAmount);
				return fixed4(col, 1);
			}

			ENDCG
		}
	}
}