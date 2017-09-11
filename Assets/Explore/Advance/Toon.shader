Shader "Explore/Toon"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex ("Texture", 2D) = "white" {}
		_RampMap("Ramp Map", 2D) = "white"{}
		_BumpMap ("Bump Map", 2D) = "bump"{}
		_Specular ("Specular Map", 2D) = ""{}
		_SpeColor("Specular Color", Color)=(1,1,1,1)
		_Gloss("Gloss", Range(0, 0.1)) = 0.01
		_RimColor("Rim Color", Color) = (1,1,1,1)
		_RimPower("Rim Power", Range(0, 10)) = 5
		_Outline("Outline", Range(0, 0.1)) = 0.05
		_OutlineColor("Outline Color", Color) = (1,1,1,1)
		_Factor("Outline Factor", Range(0, 1)) = 0.5
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
			float4 tangent:TANGENT;
		};

		struct v2f
		{
			float4 pos : SV_POSITION;
			float2 uv : TEXCOORD0;
			float3 light:TEXCOORD1;
			float3 view:TEXCOORD2;
		};

		sampler2D _MainTex;
		float4 _MainTex_ST;
		sampler2D _BumpMap;
		float4 _BumpMap_ST;
		sampler2D _Specular;
		float4 _Specular_ST;
		sampler2D _RampMap;
		float4 _Color;
		float4 _SpeColor;
		float4 _OutlineColor;
		float4 _RimColor;
		float _Gloss;
		float _Factor;
		float _Outline;
		float _RimPower;
		float _Fresnel;

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
			TANGENT_SPACE_ROTATION;
			o.light = mul(rotation, ObjSpaceLightDir(v.vertex));
			o.view = mul(rotation, ObjSpaceViewDir(v.vertex));

			return o;
		}

		fixed4 frag(v2f i):SV_Target
		{
			fixed3 light = normalize(i.light);
			fixed3 view = normalize(i.view);
			fixed3 normal = UnpackNormal(tex2D(_BumpMap, i.uv));
			fixed3 h = normalize(light + view);

			float nl = saturate(dot(normal, light));
			float nv = saturate(dot(normal, view));
			float nh = saturate(dot(normal, h));

			fixed3 ramp = tex2D(_RampMap, float2(nl, nl)).xyz;
			fixed4 albedo = tex2D(_MainTex, i.uv) * _Color;
			
			float fresnel = _Fresnel + (1-_Fresnel)* pow(1-nv, 5);
			fixed3 specColor = tex2D(_Specular, i.uv);
			//fixed3 specular = specColor.rgb * _LightColor0.rgb * pow(nh, _Gloss) * fresnel;

			//toon specular
			fixed w = fwidth(nh)*2;
			fixed temp = lerp(0, 1, smoothstep(-w, w, nh + _Gloss-1) * step(0.0001, _Gloss));
			fixed3 specular = pow(specColor, 10) * _LightColor0.rgb * temp;

			fixed3 rim = _RimColor * pow(1-nv, _RimPower);

			fixed3 color = albedo.rgb * ramp + specular + rim;

			return fixed4(color, 1);
		}
		ENDCG

		Pass
		{
			Cull front
			Offset 1,1

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
