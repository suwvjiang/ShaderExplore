// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Explore/MT"
{
    Properties
	{
		_Color("Color", Color) = (0.79,0.79,0.79,1)
		_MainTex("MainTex", 2D) = "white" {}
		_BumpMap("BumpTex", 2D) = "bump" {}
		_BumpScale("Bump Scale", Float) = 1.0
		_SpecMap("Specular Map", 2D) = "white" {}
		_SpecScale("Specular Scale", Range(1.0, 32)) = 2
		_Gloss("Gloss", Range(8.0, 256)) = 140
	}
	SubShader
	{
		LOD 200
		Tags {"RenderType"="Opaque" "Queue"="Geometry+50"}
		Pass
		{
			Name "ForwardBase"
			Tags{"LightMode"="ForwardBase"}
			CGPROGRAM
			#pragma multi_compile_fwdbase
			
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			#include "AutoLight.cginc"
			
			fixed4 _LightColor0;
			fixed4 _Color;
			sampler2D _MainTex; float4 _MainTex_ST;
			sampler2D _BumpTex; float4 _BumpTex_ST;
			sampler2D _SpecMap; float4 _SpecMap_ST;
			float _BumpScale;
			fixed _SpeScale;
			float _Gloss;
			
			struct a2v{ float4 vertex :POSITION; float3 normal:NORMAL; float4 tangent:TANGENT; float4 texcoord:TEXCOORD0; };
			struct v2f{ float4 pos:SV_POSITION; float2 uv:TEXCOORD0; float3 lightDir:TEXCOORD1; float3 viewDir:TEXCOORD2;};
			
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
				fixed3 lightDir = normalize(i.lightDir);
				fixed3 viewDir = normalize(i.viewDir);
				
				fixed3 normal = UnpackNormal(tex2D(_BumpTex, i.uv));
				normal.xy *= _BumpScale;
				normal.z = sqrt(1.0 - saturate(dot(normal.xy, normal.xy)));
				
				fixed3 albedo = tex2D(_MainTex, i.uv).rgb * _Color.rgb;
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
				fixed3 diffuse = _LightColor0.rgb * albedo * saturate(dot(normal, lightDir));
				
				fixed3 halfDir = normalize(lightDir + viewDir);
				fixed3 speValue = tex2D(_SpecMap, i.uv).rgb * _SpeScale;
				fixed3 specular = _LightColor0.rgb * speValue.rgb * pow(saturate(dot(normal, halfDir)), _Gloss);
			
				return fixed4(ambient + diffuse + specular, 1);
			}
			
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
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			#include "AutoLight.cginc"
			
			fixed4 _LightColor0;
			fixed4 _Color;
			sampler2D _MainTex; float4 _MainTex_ST;
			sampler2D _BumpTex; float4 _BumpTex_ST;
			sampler2D _SpecMap; float4 _SpecMap_ST;
			float _BumpScale;
			fixed _SpeScale;
			float _Gloss;
			
			struct a2v{ float4 vertex :POSITION; float3 normal:NORMAL; float4 tangent:TANGENT; float4 texcoord:TEXCOORD0; };
			struct v2f{ float4 pos:SV_POSITION; float2 uv:TEXCOORD0; float3 lightDir:TEXCOORD1; float3 viewDir:TEXCOORD2; };
			
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
				fixed3 lightDir = normalize(i.lightDir);
				fixed3 viewDir = normalize(i.viewDir);
				
				fixed3 normal = UnpackNormal(tex2D(_BumpTex, i.uv));
				normal.xy *= _BumpScale;
				normal.z = sqrt(1.0 - saturate(dot(normal.xy, normal.xy)));
				
				fixed3 albedo = tex2D(_MainTex, i.uv).rgb * _Color.rgb;
				fixed3 diffuse = _LightColor0.rgb * albedo * saturate(dot(normal, lightDir));
				
				fixed3 halfDir = normalize(lightDir + viewDir);
				fixed3 speValue = tex2D(_SpecMap, i.uv).rgb * _SpeScale;
				fixed3 specular = _LightColor0.rgb * speValue.rgb * pow(saturate(dot(normal, halfDir)), _Gloss);
				
				return fixed4(diffuse + specular, 1);
			}
			ENDCG
		}
	}

    FallBack "Mobile/VertexLit"
}
