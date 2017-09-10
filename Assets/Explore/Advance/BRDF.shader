Shader "Explore/BRDF"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex ("Texture", 2D) = "white" {}
		_BumpMap("Bump Map", 2D) = "bump"{}
		_BumpScale("Bump Scale", Float) = 1
		_SpecMap("Specular Map", 2D) = ""{}
		_Gloss("Gloss", Range(0, 1)) = 1
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		CGINCLUDE
		#include "UnityCG.cginc"
		#include "AutoLight.cginc"
		#include "Lighting.cginc"

		float pow2(float i)
		{
			return i * i;
		}

		float pow4(float i)
		{
			return i * i * i * i;
		}

		float pow5(float i)
		{
			return i * i * i *i * i;
		}

		float Reflectivity(fixed3 spec)
		{
			return max(max(spec.r, spec.g), spec.b);
		}

		float Tdisney(float i, float fd90)
		{
			return 1.0 +(fd90 - 1.0) * pow5(1.0 - i);
		}

		//diffuse = albedo * (1+(fd90-1)*pow((1-nl), 5))*(1+(f-1)*pow((1-nv), 5))
		//fd90 = 0.5 + 2 * preRoughness * pow(lh, 2)
		float DisneyDiffuse(float nl, float nv, float lh,float preRoughness)
		{
			float fd90 = 0.5 + 2.0 * preRoughness * pow2(lh);
			return Tdisney(nl, fd90) * Tdisney(nv, fd90);
		}

		//Fresnel = f0 + (1-f0)*pow(1-lh, 5)
		float Fresnel(float f0, float lh)
		{
			return f0 + (1.0-f0) * pow5(1.0-lh);
		}

		//Dggx = a2 / (PI * pow(((a2-1) * nh * nh + 1), 2));
		//a2 = a * a;
		float Dggx(float nh, float roughness)
		{
			float a2 = pow2(roughness);
			float t = (a2 - 1.0) * pow2(nh) + 1.0;
			return a2 / (UNITY_PI * pow2(t));
		}

		float Tg(float i, float k)
		{
			return (i * (1.0-k) + k);
		}
		
		//G(l, v) = G1(l) G1(v); 
		//G1(x) = 1 / (nx*(1 - k) + k); k = sqrt(2 * a * a / pi) = a * sqrt(2/pi); a = roughness * roughness
		//Smith-Schlick
		float Vss(float nl, float nv, float roughness)
		{
			half c = 0.797884560802865h; // c = sqrt(2 / pi)
			float k = roughness * c;
			return 1 / (Tg(nl, k) * Tg(nv, k));
		}

		// GGX
		float Vggx(float nl, float nv, float roughness)
		{
			half a = roughness;
			half lambdaV = nl * (nv * (1 - a) + a);
			half lambdaL = nv * (nl * (1 - a) + a);

			return 2.0 / (lambdaV + lambdaL + 1e-5f);
		}

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
			float4 t2wx:TEXCOORD1;
			float4 t2wy:TEXCOORD2;
			float4 t2wz:TEXCOORD3;
			SHADOW_COORDS(4)
		};

		sampler2D _MainTex;
		float4 _MainTex_ST;
		sampler2D _BumpMap;
		float4 _BumpMap_ST;
		sampler2D _SpecMap;
		float4 _SpecMap_ST;
		float4 _Color;
		float _BumpScale;
		float _Gloss;
		
		v2f vert (a2v v)
		{
			v2f o;
			o.pos = UnityObjectToClipPos(v.vertex);
			o.uv = TRANSFORM_TEX(v.uv, _MainTex);

			float3 posWorld = mul(unity_ObjectToWorld, v.vertex);
			float3 normalWorld = UnityObjectToWorldNormal(v.normal);
			float3 tangentWorld = UnityObjectToWorldDir(v.tangent);
			float3 binWorld = cross(normalWorld, tangentWorld) * v.tangent.w;

			o.t2wx = float4(tangentWorld.x, binWorld.x, normalWorld.x, posWorld.x);
			o.t2wy = float4(tangentWorld.y, binWorld.y, normalWorld.y, posWorld.y);
			o.t2wz = float4(tangentWorld.z, binWorld.z, normalWorld.z, posWorld.z);

			TRANSFER_SHADOW(o);
			return o;
		}
		
		fixed4 frag (v2f i) : SV_Target
		{
			float3 pos = float3(i.t2wx.w, i.t2wy.w, i.t2wz.w);
			float3 bump = UnpackNormal(tex2D(_BumpMap, i.uv));
			bump.xy *= _BumpScale;
			bump.z = 1-sqrt(dot(bump.xy, bump.xy));

			float3 normal = float3(dot(i.t2wx.xyz, bump), dot(i.t2wy.xyz, bump), dot(i.t2wz.xyz, bump));
			normal = normalize(normal);
			float3 light = normalize(UnityWorldSpaceLightDir(pos));
			float3 view = normalize(UnityWorldSpaceViewDir(pos));
			float3 h = normalize(light+view);

			float nl = saturate(dot(normal, light));
			float nv = abs(dot(normal, view));
			float lh = saturate(dot(light, h));
			float nh = saturate(dot(normal, h));

			// sample the texture
			fixed4 albedo = tex2D(_MainTex, i.uv) * _Color;
			fixed4 spec = tex2D(_SpecMap, i.uv);

			float smoothness = spec.a * _Gloss;
			float perRoughness = 1-smoothness;
			float roughness = pow2(perRoughness);
			float oneMinusReflectivity = 1 - Reflectivity(spec);

			//Conservation Energy
			albedo = albedo * oneMinusReflectivity;

			//PreMultiplyAlpha
			albedo.rgb *= albedo.a;
			
			//diffuse
			float diffTerm = DisneyDiffuse(nl, nv, lh, perRoughness);
			diffTerm *= nl;
			
			//specular = F * D * G/(4*nl*nv) = F * D * V / 4
			//其中V = G / (nl*nv)
			float F = Fresnel(1-oneMinusReflectivity, lh);

			float D = Dggx(nh, roughness);
			//float D = Dbp(nh, roughness);

			float V = Vss(nl, nv, roughness);
			//float V = Vggx(nl, nv, roughness);

			float specTerm = F * D * V / 4 * UNITY_PI;
			specTerm = max(0, specTerm * nl);

			//shadow and atten
			UNITY_LIGHT_ATTENUATION(atten, i, pos);

			fixed3 diffuse = albedo * _LightColor0.rgb * diffTerm * atten;
			fixed3 specular = spec * _LightColor0.rgb * specTerm * atten;
			fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;

			fixed3 finishC = diffuse + specular + ambient;

			return fixed4(finishC, 1);
		}
		ENDCG

		Pass
		{
			Tags {"LightMode"="ForwardBase"}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fwdbase
			
			ENDCG
		}
	}
	Fallback "Specular"
}
