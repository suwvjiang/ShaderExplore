Shader "Explore/Cloud2D"
{
	Properties
	{
		_SkyColor("Sky Color", Color) = (1,1,1,1)
		_CloudColor ("Cloude Color", Color) = (1,1,1,1)
		_Octave0 ("Octave 0", 2D) = "white" {}
		_Octave1 ("Octave 1", 2D) = "white" {}
		_Octave2 ("Octave 2", 2D) = "white" {}
		_Octave3 ("Octave 3", 2D) = "white" {}
		_Speed ("Speed", Range(0, 1)) = 0.5
		_Emptiness("Emptiness", Range(0, 1)) = 0.2
		_Shapeness("_Shapeness", Range(0, 1)) = 0.8
	}
	SubShader
	{
		Tags {"RenderType"="Opaque" "Queue"="Geometry"}
		Cull Off ZWrite Off
		LOD 100

		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0

			#include "UnityCG.cginc"

			half4 _SkyColor;

			struct appdata_t {
				float4 vertex : POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct v2f {
				float4 pos : SV_POSITION;
				float3 texcoord : TEXCOORD0;
			};

			v2f vert (appdata_t v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				return o;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				return _SkyColor;
			}
			ENDCG 
		}

		Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct a2v
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float4 uv : TEXCOORD0;
				float4 uv1 : TEXCOORD1;
			};

			sampler2D _Octave0; float4 _Octave0_ST;
			sampler2D _Octave1; float4 _Octave1_ST;
			sampler2D _Octave2; float4 _Octave2_ST;
			sampler2D _Octave3; float4 _Octave3_ST;
			float4 _CloudColor;
			float _Speed;
			float _Emptiness;
			float _Shapeness;
			
			v2f vert (a2v v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv.xy = TRANSFORM_TEX(v.uv, _Octave0) + _Time.x * _Speed * float2(1.0, 0.0);
				o.uv.zw = TRANSFORM_TEX(v.uv, _Octave1) + _Time.x * _Speed * float2(0.0, 1.0);
				o.uv1.xy = TRANSFORM_TEX(v.uv, _Octave2) + _Time.x * _Speed * float2(-1.0, 0.0);
				o.uv1.zw = TRANSFORM_TEX(v.uv, _Octave3) + _Time.x * _Speed * float2(0.0, -1.0);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 noise1 = tex2D(_Octave0, i.uv.xy);
				fixed4 noise2 = tex2D(_Octave1, i.uv.zw);
				fixed4 noise3 = tex2D(_Octave2, i.uv1.xy);
				fixed4 noise4 = tex2D(_Octave3, i.uv1.zw);

				fixed4 fbm = noise1 * 0.5 + noise2 * 0.25 + noise3 * 0.125 + noise4 * 0.0625;
				fbm = (clamp(fbm, _Emptiness, _Shapeness) - _Emptiness)/(_Shapeness - _Emptiness);

				fixed4 ray = (0, 0.2, 0.4, 0.6);
				fixed amount = dot(max(fbm - ray, 0), (0.25, 0.25, 0.25, 0.25));

				fixed4 color;
				color.rgb = _CloudColor.rgb * amount;
				color.a = amount * 1.5;
				return color;
			}
			ENDCG
		}
	}
}
