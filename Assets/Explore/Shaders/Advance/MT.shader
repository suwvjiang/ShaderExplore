// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Explore/MT"
{
    Properties
	{
		_Color("Color", Color) = (0.79,0.79,0.79,1)
		_MainTex("MainTex", 2D) = "white" {}
		_BumpTex("BumpTex", 2D) = "bump" {}
		_BumpScale("Bump Scale", Float) = 1.0
		_Specular("Specular", 2D) = "white" {}
		_SpeScale("Specular Scale", Range(1.0, 32)) = 2
		_Gloss("Gloss", Range(8.0, 256)) = 140
		_Emissive("Emissive", 2D) = "black" {}
		[MaterialToggle]_Breath("Breath", Float) = 0
	}
	SubShader
	{
		LOD 400
		Tags {"RenderType"="Opaque" "Queue"="Geometry+50"}

		CGINCLUDE

		#include "UnityCG.cginc"
		#include "AutoLight.cginc"
		
		fixed4 _LightColor0;
		fixed4 _Color;
		sampler2D _MainTex; float4 _MainTex_ST;
		sampler2D _BumpTex; float4 _BumpTex_ST;
		sampler2D _Specular; float4 _Specular_ST;
		sampler2D _Emissive; float4 _Emissive_ST;
		float _BumpScale;
		fixed _SpeScale;
		float _Gloss;
		fixed _Breath;
		
		struct a2v
		{ 
			float4 vertex :POSITION; 
			float3 normal:NORMAL; 
			float4 tangent:TANGENT; 
			float4 texcoord:TEXCOORD0; 
		};

		struct v2f
		{ 
			float4 pos:SV_POSITION; 
			float2 uv:TEXCOORD0; 
			float3 lightDir:TEXCOORD1; 
			float3 viewDir:TEXCOORD2;
		};
		
		v2f vert(a2v v)
		{
			v2f o;
			o.pos = UnityObjectToClipPos(v.vertex);
			o.uv= TRANSFORM_TEX(v.texcoord, _MainTex);
			TANGENT_SPACE_ROTATION;
			o.lightDir = mul(rotation, ObjSpaceLightDir(v.vertex)).xyz;
			o.viewDir = mul(rotation, ObjSpaceViewDir(v.vertex)).xyz;
			
			return o;
		}
		
		fixed4 frag(v2f i):SV_Target
		{
			half3 lightDir = normalize(i.lightDir);
			half3 viewDir = normalize(i.viewDir);
			half3 halfDir = normalize(i.lightDir + i.viewDir);
			
			half3 normal = UnpackNormal(tex2D(_BumpTex, i.uv));
			normal.xy *= _BumpScale;
			normal.z = sqrt(1.0 - saturate(dot(normal.xy, normal.xy)));

			half nv = saturate(dot(normal, viewDir));
			half nl = saturate(dot(normal, lightDir));
			half nh = saturate(dot(normal, halfDir));
			
			half3 albedo = tex2D(_MainTex, i.uv).rgb;
			albedo = GammaToLinearSpace(albedo) * _Color.rgb;
			half3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
			half3 diffuse = _LightColor0.rgb * albedo * nv;
			
			half3 speValue = tex2D(_Specular, i.uv).rgb * _SpeScale;
			half3 specular = _LightColor0.rgb * speValue.rgb * pow(nh, _Gloss);
			
			half3 emissive = tex2D(_Emissive, i.uv).rgb * ((_SinTime.z*0.5+0.5) * _Breath + (1-_Breath));
			
			half3 color = ambient + diffuse + specular + emissive;
			return fixed4(color, 1);
		}
		
		fixed4 fragAdd(v2f i):SV_Target
		{
			half3 lightDir = normalize(i.lightDir);
			half3 viewDir = normalize(i.viewDir);
			half3 halfDir = normalize(lightDir + viewDir);
			
			half3 normal = UnpackNormal(tex2D(_BumpTex, i.uv));
			normal.xy *= _BumpScale;
			normal.z = sqrt(1.0 - saturate(dot(normal.xy, normal.xy)));

			half nl = saturate(dot(normal, lightDir));
			half nh = saturate(dot(normal, halfDir));
			
			half3 albedo = tex2D(_MainTex, i.uv).rgb;
			albedo = GammaToLinearSpace(albedo) * _Color.rgb;
			half3 diffuse = _LightColor0.rgb * albedo * nl;
			
			half3 speValue = tex2D(_Specular, i.uv).rgb * _SpeScale;
			half3 specular = _LightColor0.rgb * speValue.rgb * pow(nh, _Gloss);
			half3 color = diffuse + specular;

			return fixed4(color, 1);
		}
		ENDCG

		Pass
		{
			Name "ForwardBase"
			Tags{"LightMode"="ForwardBase"}
			CGPROGRAM
			#pragma multi_compile_fwdbase
			
			#pragma vertex vert
			#pragma fragment frag
			ENDCG
		}

		Pass
		{
			Name "ForwardAdd"
			Tags{"LightMode"="ForwardAdd"}
			Blend One One
			
			CGPROGRAM
			#pragma multi_compile_fwdadd
			
			#pragma vertex vert
			#pragma fragment fragAdd
			ENDCG
		}
	}
	
	Fallback "Specular"
}
