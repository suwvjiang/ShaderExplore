Shader "Explore/Toon"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex ("Texture", 2D) = "white" {}
		_SpeColor("Specular Color", Color)=(1,1,1,1)
		_Gloss("Gloss", Range(1, 64)) = 16
		_RampMap("Ramp Map", 2D) = "white"{}
		_RimColor("Rim Color", Color) = (1,1,1,1)
		_RimPower("Rim Power", Range(0, 10)) = 5
		_Factor("Outline Factor", Range(0, 1)) = 0.5
		_Outline("Outline", Range(0, 0.1)) = 0.05
		_OutlineColor("Outline Color", Color) = (1,1,1,1)
		_SpecularFresnel("Specular Fresnel", Range(0, 1)) = 0.5
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		CGINCLUDE

		#include "UnityCG.cginc"
		#include "Lighting.cginc"

		struct a2v
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
		};

		sampler2D _MainTex;
		float4 _MainTex_ST;
		sampler2D _RampMap;
		float4 _Color;
		float4 _SpeColor;
		float4 _OutlineColor;
		float4 _RimColor;
		float _Gloss;
		float _Factor;
		float _Outline;
		float _RimPower;
		float _SpecularFresnel;

		v2f outlineVert (a2v v)
		{
			v2f o;
			fixed3 dir = v.vertex.xyz;
			float d = dot(dir, v.normal);
			dir *= sign(d);
			fixed3 outline = lerp(v.normal, dir, _Factor);
			o.pos = UnityObjectToClipPos(v.vertex + outline * _Outline);
			return o;
		}
		
		fixed4 outlineFrag (v2f i) : SV_Target
		{
			return _OutlineColor;
		}

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
			fixed3 light = normalize(UnityWorldSpaceLightDir(i.worldPos));
			fixed3 view = normalize(UnityWorldSpaceViewDir(i.worldPos));
			fixed3 normal = normalize(i.worldNormal);

			half lam = dot(normal, light) * 0.5 + 0.5;
			fixed3 ramp = tex2D(_RampMap, float2(lam, lam)).xyz;

			fixed4 albedo = tex2D(_MainTex, i.uv) * _Color;
			
			float vdotn = dot(view, normal);
			float fresnel = _SpecularFresnel + (1-_SpecularFresnel)* pow(1-vdotn, 5);
			fixed3 h = normalize(view + light);
			fixed temp = saturate(dot(h, normal));
			fixed3 specular = _SpeColor.rgb * _LightColor0.rgb * pow(temp, _Gloss) * fresnel;

			//toon specular
			//fixed3 spec = dot(normal, normalize(view + light));
			//fixed w = fwidth(spec)*2;
			//fixed temp = lerp(0, 1, smoothstep(-w, w, spec + _SpecularScale-1) * step(0.0001, _SpecularScale));
			//fixed3 specular = _SpeColor.rgb * _LightColor0.rgb * temp;

			fixed3 rim = _RimColor * pow(1-dot(view, normal), _RimPower);

			return fixed4(albedo.rgb * ramp + specular + rim, 1);
		}
		ENDCG

		Pass
		{
			Cull front

			CGPROGRAM
			#pragma vertex outlineVert
			#pragma fragment outlineFrag

			ENDCG
		}

		Pass
		{
			Tags {"LightMode"="ForwardBase"}
			Cull back
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fwdbase
			ENDCG
		}
	}
}
