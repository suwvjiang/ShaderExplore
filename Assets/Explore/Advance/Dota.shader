// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Explore/DOTA"
{
    Properties
	{
		_Color("Color", Color) = (0.79,0.79,0.79,1)
		_MainTex("MainTex", 2D) = "white" {}
		_CubeMap("Cube Map", Cube) = ""{}
		_DetailMap("Detail Map", 2D) = ""{}
		_DiffWrap("Diffuse Wrap", 2D) = ""{}
		_ColorWrap("Color Wrap", 2D) = ""{}
		_RimWrap("Rim Wrap", 2D) = ""{}
		_SpecWrap("Specular Wrap", 2D) = ""{}
		_MatelnessMask("Matalness Mask", 2D) =""{}
		_BumpMap("BumpTex", 2D) = "bump" {}
		_RimMask("Rim Mask", 2D) = ""{}
		_SelfIllumMask("Self Illum Mask", 2D) = ""{}
		_SpecExponment("Specular Exponment", 2D) = ""{} 
		_Specular("Specular Mask", 2D) = "white" {}
		_TintBaseMask("Tiny Mask", 2D) = ""{}
		_Translucency("Translucency", 2D) = ""{}
	}
	SubShader
	{
		LOD 400
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
			sampler2D _BumpMap; float4 _BumpMap_ST;
			sampler2D _DetailMap; float4 _DetailMap_ST;
			sampler2D _DiffWrap; float4 _DiffWrap_ST;
			sampler2D _ColorWrap; float4 _ColorWrap_ST;
			sampler2D _RimWrap; float4 _RimWrap_ST;
			sampler2D _SpecWrap; float4 _SpecWrap_ST;
			sampler2D _MatelnessMask; float4 _MatelnessMask_ST;
			sampler2D _RimMask; float4 _RimMask_ST;
			sampler2D _SelfIllumMask; float4 _SelfIllumMask_ST;
			sampler2D _SpecExponment; float4 _SpecExponment_ST;
			sampler2D _Specular; float4 _Specular_ST;
			sampler2D _TintBaseMask; float4 _TintBaseMask_ST;
			sampler2D _Translucency; float4 _Translucency_ST;
			samplerCUBE _CubeMap;
			
			struct a2v
			{ 
				float4 vertex :POSITION; 
				float2 texcoord:TEXCOORD0;
				float3 normal:NORMAL; 
				float4 tangent:TANGENT; 
			};
			struct v2f
			{ 
				float4 pos:SV_POSITION; 
				float2 uv:TEXCOORD0; 
				float4 t2wx:TEXCOORD1; 
				float4 t2wy:TEXCOORD2;
				float4 t2wz:TEXCOORD3;
				float3 viewW:TEXCOORD4;
				float3 reflect:TEXCOORD5;
			};
			
			v2f vert(a2v v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv= TRANSFORM_TEX(v.texcoord, _MainTex);

				float3 posW = mul(unity_ObjectToWorld, v.vertex);
				float3 normalW = UnityObjectToWorldNormal(v.normal);
				float3 tangentW = UnityObjectToWorldDir(v.tangent);
				float3 binormalW = cross(normalW, tangentW) * v.tangent.w;

				o.t2wx = float4(tangentW.x, binormalW.x, normalW.x, posW.x);
				o.t2wy = float4(tangentW.y, binormalW.y, normalW.y, posW.y);
				o.t2wz = float4(tangentW.z, binormalW.z, normalW.z, posW.z);
				o.viewW = normalize(UnityWorldSpaceViewDir(posW));
				o.reflect = reflect(-o.viewW, normalW);
				return o;
			}
			
			fixed4 frag(v2f i):SV_Target
			{
				float3 pos = float3(i.t2wx.w, i.t2wy.w, i.t2wz.w);
				fixed3 light = normalize(UnityWorldSpaceLightDir(pos));
				fixed3 view = normalize(i.viewW);
				
				fixed3 bump = UnpackNormal(tex2D(_BumpMap, i.uv));
				bump.z = sqrt(1.0 - saturate(dot(bump.xy, bump.xy)));
				fixed3 normal = fixed3(dot(i.t2wx.xyz, bump), dot(i.t2wy.xyz, bump), dot(i.t2wz.xyz, bump));

				float3 h = normalize(light + view);
				float nv = saturate(dot(normal, view));
				float nl = saturate(dot(normal, light));
				float nh = saturate(dot(normal, h));
				float rv = saturate(dot(view, i.reflect));

				//float fresnel = _Fresnel + (1-_Fresnel)*pow(nv, 5);

				//AlphaTest
				fixed3 translucency = tex2D(_Translucency, i.uv).rgb;
				clip(translucency.r - 0.5);

				//diffuse
				fixed3 albedo = tex2D(_MainTex, i.uv).rgb * _Color.rgb;
				fixed3 diffuse = _LightColor0.rgb * albedo;
				
				//specular
				fixed3 specExp = tex2D(_SpecExponment, i.uv).rgb;
				float specPower = pow(nh, specExp.r);
				fixed3 specWrap = tex2D(_SpecWrap, float2(specPower, specPower));
				//tint
				fixed3 tintMask = tex2D(_TintBaseMask, i.uv).rgb;
				fixed3 specular = lerp(specWrap, diffuse, tintMask.r);
				//mask
				fixed3 specMask = tex2D(_Specular, i.uv).rgb;
				specular = specWrap * specMask.rgb * specPower;

				//rim
				fixed3 rimIntensity = tex2D(_RimMask, i.uv);
				fixed3 rim = rimIntensity * saturate(1 - nv * 1.8);

				//selfIllum
				fixed3 colorWrap = tex2D(_ColorWrap, float2(nl, nl)).rgb;
				fixed3 diffWrap = tex2D(_DiffWrap, float2(nl, nl)).rgb;
				float selfIllu = tex2D(_SelfIllumMask, i.uv).r;
				fixed3 diffuseReflection = albedo * lerp(diffWrap, float3(1, 1, 1) * 2, selfIllu);

				//mateliic
				fixed3 matellic = tex2D(_MatelnessMask, i.uv);
				fixed matel = min(matellic, 1.0);

				//fixed3 ref = texCUBE(_CubeMap, i.reflectw).rgb;
				//diffuse = lerp(diffuse, ref, fresnel);
				fixed3 finish = (diffuse + rim) + specular + diffuseReflection;
				
				return fixed4(finish, 1);
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
			sampler2D _Specular; float4 _Specular_ST;
			sampler2D _Emissive; float4 _Emissive_ST;
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
				fixed3 speValue = tex2D(_Specular, i.uv).rgb * _SpeScale;
				fixed3 specular = _LightColor0.rgb * speValue.rgb * pow(saturate(dot(normal, halfDir)), _Gloss);
				
				return fixed4(diffuse + specular, 1);
			}
			ENDCG
		}
	}

	SubShader
	{
		LOD 200
		Tags {"RenderType"="Opaque" "Queue"="Geometry+50"}

		UsePass "MT/Monster/FORWARDBASE"
	}
    FallBack "Mobile/VertexLit"
}
