Shader "Explore/PointDissolve"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Threshold("Threshold", Range(0, 1)) = 0
		_MaxDistance("MaxDistance", Float) = 1
		_DistanceEffect("Distance Effect", Range(0, 1)) = 0.5
		_Origin("Origin Point", Vector) = (0,0,0,0)
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
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
			float4 _MainTex_ST;
			float _Threshold;
			float _MaxDistance;
			float _DistanceEffect;
			float3 _Origin;
			
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
				float noise = simplexFBM(i.worldPos, 5, 1, 2, 1, 0.5);
				float dis = length(i.worldPos - _Origin)/_MaxDistance;
				float cutout = lerp(noise, dis, _DistanceEffect);
				clip(cutout - _Threshold);

				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				return col;
			}
			ENDCG
		}
	}
}
