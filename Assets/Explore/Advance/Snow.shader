Shader "Explore/Snow"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_BumpMap ("Bump Map", 2D) = "bump"{}
		_Gloss ("Gloss", Range(1, 256)) = 8
		_SnowLevel ("Snow Level", Range(0, 0.5)) = 0.5
		_SnowColor ("Snow Color", Color) = (1,1,1,1)
		_SnowDirection ("Snow Direction", Vector) = (0, 1, 0, 1)
		_Wetness ("Wedness", Range(0, 1)) = 0
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		CGINCLUDE

		#include "UnityCG.cginc"
		#include "AutoLight.cginc"
		#include "Lighting.cginc"

		struct a2v
		{
			float4 vertex : POSITION;
			float2 uv : TEXCOORD0;
			float3 normal : NORMAL;
			float4 tangent : TANGENT;
		};

		struct v2f
		{
			float4 pos : SV_POSITION;
			float2 uv : TEXCOORD0;
			float4 t2w[3] : TEXCOORD1;
			SHADOW_COORDS(4)
		};

		sampler2D _MainTex;
		float4 _MainTex_ST;
		sampler2D _BumpMap;
		float4 _BumpMap_ST;
		float4 _SnowColor;
		float4 _SnowDirection;
		float _Gloss;
		float _SnowLevel;
		float _SnowDepth;
		float _Wetness;
		
		v2f vert (a2v v)
		{
			v2f o;
			o.pos = UnityObjectToClipPos(v.vertex);
			o.uv = TRANSFORM_TEX(v.uv, _MainTex);

			float3 pos = mul(unity_ObjectToWorld, v.vertex);
			float3 normal = UnityObjectToWorldNormal(v.normal);
			float3 tangent = UnityObjectToWorldDir(v.tangent);
			float3 binormal = cross(normal, tangent.xyz) * v.tangent.w;

			o.t2w[0] = float4(tangent.x, binormal.x, normal.x, pos.x);
			o.t2w[1] = float4(tangent.y, binormal.y, normal.y, pos.y);
			o.t2w[2] = float4(tangent.z, binormal.z, normal.z, pos.z);
			TRANSFER_SHADOW(o);

			return o;
		}
		
		fixed4 frag (v2f i) : SV_Target
		{
			float3 pos = float3(i.t2w[0].w, i.t2w[1].w, i.t2w[2].w);
			float3 light = normalize(UnityWorldSpaceLightDir(pos));
			float3 view = normalize(UnityWorldSpaceViewDir(pos));
			float3 halfDir = normalize(light + view);

			float3 bump = UnpackNormal(tex2D(_BumpMap, i.uv));
			float3 normal = float3(dot(i.t2w[0].xyz, bump), dot(i.t2w[1].xyz, bump), dot(i.t2w[2].xyz, bump));
			normal = normalize(normal);

			float nl = saturate(dot(normal, light));
			float nh = saturate(dot(normal, halfDir));
			float nv = saturate(dot(normal, view));
			float ns = dot(normal, normalize(_SnowDirection.xyz));

			// sample the texture
			fixed4 albedo = tex2D(_MainTex, i.uv);

			fixed diff = ns - lerp(1, -1, _SnowLevel);
			diff = saturate(diff * (1-_Wetness)/(_Wetness + 0.0001f));
			albedo = lerp(albedo, _SnowColor, diff);

			fixed3 diffuse = albedo.rgb * _LightColor0.xyz * nv;
			fixed3 specular = _LightColor0.rgb * pow(nh, _Gloss);
			fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb * albedo;
			
			UNITY_LIGHT_ATTENUATION(atten, i, pos)

			fixed3 finish = diffuse + ambient;
			return fixed4(finish, 1);
		}
		ENDCG

		Pass
		{
			Cull off
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			ENDCG
		}
	}
}
