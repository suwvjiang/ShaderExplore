Shader "Explore/TimeGray"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_RampTex("Ramp Texture", 2D) = ""{}
		_AlphaTest("Alpha Test", Range(0, 1)) = 0.5
		_DistanceEffect("Distance Effect", Range(0, 1)) = 0.5
		_NoiseRange("Noise Range", Range(0, 0.1)) = 0.01
		_Speed("Speed", Range(0, 20)) = 4
	}
	SubShader
	{
		Tags { "RenderType"="TransparentCutout" "Queue"="AlphaTest"}
		LOD 100

		CGINCLUDE

		#include "UnityCG.cginc"
		#include "../../CgIncludes/NoiseCG.cginc"

		struct appdata
		{
			float4 vertex : POSITION;
			float2 uv : TEXCOORD0;
		};

		struct v2f
		{
			float4 pos : SV_POSITION;
			float2 uv : TEXCOORD0;
			float3 worldPos:TEXCOORD1;
		};

		sampler2D _MainTex;
		sampler2D _RampTex;
		float4 _MainTex_ST;
		float _AlphaTest;
		float _DistanceEffect;
		float _NoiseRange;
		float _Speed;

		uniform float _MaxDistance;
		uniform float3 _Origin;
		uniform float _Threshold;

		
		v2f vert (appdata v)
		{
			v2f o;
			o.pos = UnityObjectToClipPos(v.vertex);
			o.uv = TRANSFORM_TEX(v.uv, _MainTex);
			o.worldPos = mul(unity_ObjectToWorld, v.vertex);
			return o;
		}
		
		fixed4 frag (v2f i) : SV_Target
		{
			// sample the texture
			fixed4 col = tex2D(_MainTex, i.uv);
			clip(col.a - _AlphaTest);

			float noise = valueFBM(i.worldPos, 4, 1, 2, 1, 0.5);
			float dis = length(i.worldPos - _Origin)/_MaxDistance;
			dis = lerp(noise, dis, _DistanceEffect);
			float temp = dis - _Threshold;

			if(temp > _NoiseRange)
			{
				col.rgb = dot(float3(0.2125, 0.7154, 0.0721), col.rgb);;
			}
			else if(temp <= _NoiseRange && temp >= 0)
			{
				col.rgb = tex2D(_RampTex, float2(temp/_NoiseRange, 0)).rgb;
			}

			return col;
		}
		ENDCG

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			ENDCG
		}
	}
}
