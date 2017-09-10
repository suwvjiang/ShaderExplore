Shader "Explore/Glass"
{
	Properties
	{
		_BumpMap ("Normal Map", 2D) = "bump" {}
		_RefractRatio("Refract Ratio", Range(0, 1)) = 1
	}
	SubShader
	{
		Tags { "RenderType"="Transparent" "Queue"="Transparent"}
		LOD 100

		GrabPass {"_RenderTexture"}

		Pass
		{
			Tags {"LightMode"="ForwardBase"}
			Blend SrcAlpha OneMinusSrcAlpha
			ZWrite Off Cull Off

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fwdbase
			
			#include "UnityCG.cginc"

			struct a2v
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				float4 screenPos:TEXCOORD1;
			};

			sampler2D _BumpMap;
			float4 _BumpMap_ST;
			sampler2D _RenderTexture;
			float _RefractRatio;

			v2f vert (a2v v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _BumpMap);
				o.screenPos = ComputeGrabScreenPos(o.pos);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed3 bump = UnpackNormal(tex2D(_BumpMap, i.uv));

				float2 offset = bump.xy * _RefractRatio;
				fixed2 uv = (i.screenPos.xy + offset)/i.screenPos.w;
				fixed4 color = tex2D(_RenderTexture, uv);

				return fixed4(color);
			}
			ENDCG
		}
	}
}
