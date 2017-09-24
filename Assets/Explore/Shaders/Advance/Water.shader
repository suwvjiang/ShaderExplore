Shader "Explore/Water"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_BumpMap ("Bump Map", 2D) = "bump"{}
		_DepthMap("Depth Color Map", 2D) = ""{}
		_WaveMap ("Wave Map", 2D) = ""{}
		_NoiseMap("Noise Map", 2D) = ""{}
		_CubeMap ("Cube Map", Cube) = ""{}
		_RefractRatio("Refract Ratio", Range(0, 0.1)) = 0.7
		_WaterSpeed("Water Speed", Range(0, 1)) = 0.74
		_WaveSpeed("Wave Speed", Float) = -12.64
		_WaveRange("Wave Range", Range(0, 1)) = 0.3
		_WaveDelta("Wave Delta", Range(0, 6.28)) = 2.43
		_NoiseRange("Noise Range", Range(0, 15)) = 6.43
		_Gloss("Gloss", Range(1, 256)) = 128
		_Fresnel("Fresnel", Range(0, 1)) = 0
		_RangeInfos("Range Infos", Vector) = (1.53, 0.37, 0.78, 0.13)//maxDepth, Refract, Wave, alpha
	}
	SubShader
	{
		Tags { "RenderType"="Transparent" "Queue"="Transparent"}
		LOD 100

		GrabPass {"_RefractTexture"}

		CGINCLUDE

		#include "UnityCG.cginc"
		#include "Lighting.cginc"

		float DepthToPercent(float depth, float maxDepth)
		{
			return min(depth, maxDepth)/maxDepth;
		}

		float2 VerticallyUV(float2 uv)
		{
			return float2(1-uv.y, uv.x);
		}

		struct a2v
		{
			float4 vertex : POSITION;
			float2 uv : TEXCOORD0;
			float3 normal : NORMAL;
			float4 tangent:TANGENT;
		};

		struct v2f
		{
			float4 pos : SV_POSITION;
			float2 uv : TEXCOORD0;
			float4 proj:TEXCOORD1;
			float4 t2w[3]:TEXCOORD2;
		};

		sampler2D _MainTex; float4 _MainTex_ST;
		sampler2D _BumpMap; float4 _BumpMap_ST;
		sampler2D _DepthMap; float4 _DepthMap_ST;
		sampler2D _WaveMap; float4 _WaveMap_ST;
		sampler2D _NoiseMap; float4 _NoiseMap_ST;
		sampler2D _CameraDepthTexture;
		sampler2D _RefractTexture;
		samplerCUBE _CubeMap;
		float4 _RangeInfos;
		float _RefractRatio;//折射率
		float _WaterSpeed;
		float _WaveRange;
		float _WaveSpeed;
		float _WaveDelta;
		float _NoiseRange;
		float _Gloss;
		float _Fresnel;

		v2f vert (a2v v)
		{
			v2f o;
			o.pos = UnityObjectToClipPos(v.vertex);
			o.uv = TRANSFORM_TEX(v.uv, _MainTex);
			o.proj = ComputeGrabScreenPos(o.pos);
			COMPUTE_EYEDEPTH(o.proj.z);

			float3 pos = mul(unity_ObjectToWorld, v.vertex);
			float3 normal = UnityObjectToWorldNormal(v.normal);
			float3 tangent = UnityObjectToWorldDir(v.tangent);
			float3 binormal = cross(normal, tangent) * v.tangent.w;

			o.t2w[0] = float4(tangent.x, binormal.x, normal.x, pos.x);
			o.t2w[1] = float4(tangent.y, binormal.y, normal.y, pos.y);
			o.t2w[2] = float4(tangent.z, binormal.z, normal.z, pos.z);
			return o;
		}
		
		fixed4 frag (v2f i) : SV_Target
		{
			float3 pos = float3(i.t2w[0].w, i.t2w[1].w, i.t2w[2].w);
			float3 light = normalize(UnityWorldSpaceLightDir(pos));
			float3 view  = normalize(UnityWorldSpaceViewDir(pos));
			float3 halfDir = normalize(light + view);

			float2 uv = i.proj.xy / i.proj.w;
			float depth = LinearEyeDepth(tex2D(_CameraDepthTexture, uv).r);
			float waterDepth = depth - i.proj.z;

			float depthPer = DepthToPercent(waterDepth, _RangeInfos.x);
			float surface = 1 - DepthToPercent(waterDepth, _RangeInfos.y);
			float ref = DepthToPercent(waterDepth, _RangeInfos.z);
			fixed alpha = DepthToPercent(waterDepth, _RangeInfos.w);

			float4 depthColor = tex2D(_DepthMap, float2(depthPer, 1));//水深颜色
			depthColor.rgb *= alpha;
			
			float2 waterOffset = float2(_Time.x, 0) * _WaterSpeed;
			fixed4 waterColor = (tex2D(_MainTex, i.uv + waterOffset) + tex2D(_MainTex, VerticallyUV(i.uv) + waterOffset)) * 0.5;//取相互垂直的两份水波纹理
			waterColor.rgb *= waterColor.a;

			float4 offsetMap = (tex2D(_BumpMap, i.uv + waterOffset) + tex2D(_BumpMap, VerticallyUV(i.uv) + waterOffset)) * 0.5;
			float2 offset = UnpackNormal(offsetMap).xy * _RefractRatio;

			fixed3 refractColor = tex2D(_RefractTexture, uv + offset * depthPer * 0.5);

			float3 noise = tex2D(_NoiseMap, i.uv);

			float waveOffset1 = sin(_Time.x * _WaveSpeed + noise.r * _NoiseRange);
			float3 wave_1 = tex2D(_WaveMap, float2(1 - surface + _WaveRange * waveOffset1, 1));
			wave_1 *= (1- (waveOffset1 + 1)/2) * noise.r;

			float waterOffset2 = sin(_Time.x* _WaveSpeed + _WaveDelta + noise.r * _NoiseRange);
			float3 wave_2 = tex2D(_WaveMap, float2(1 - surface + _WaveRange * waterOffset2, 1));
			wave_2 *= (1- (waterOffset2 + 1)/2) * noise.r;

			fixed3 albedo = lerp(refractColor.rgb, depthColor.rgb, ref);
			albedo = lerp(albedo, waterColor.rgb, surface * waterColor.a);
			albedo += (wave_1 + wave_2) * surface;

			float4 bumpMap = (tex2D(_BumpMap, i.uv + waterOffset + offset) + tex2D(_BumpMap, VerticallyUV(i.uv) + waterOffset + offset)) * 0.5;
			float3 normal = normalize(UnpackNormal(bumpMap));
			normal = float3(dot(i.t2w[0].xyz, normal), dot(i.t2w[1].xyz, normal), dot(i.t2w[2].xyz, normal));
			float3 refDir = reflect(-view, normal);
			refDir *= float3(1, 1, 1);

			float nl = saturate(dot(normal, light));
			float nv = saturate(dot(normal, view));
			float nh = saturate(dot(normal, halfDir));

			fixed3 specular = _LightColor0.rgb * pow(nh, _Gloss);
			fixed3 reflect = texCUBE(_CubeMap, refDir);
			specular = lerp(specular, reflect, _Fresnel);

			fixed3 color = albedo * (nl * 0.8 + 0.2) + specular;
			return fixed4(color, alpha);
		}
		ENDCG


		Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha
			ZWrite off
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			ENDCG
		}
	}
}
