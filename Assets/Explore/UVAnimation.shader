shader "Explore/UV Animation"
{
	Properties
	{
		_Maintex ("Maintex", 2D) = "white" {}
        _u ("u", Float ) = 4
        _v ("v", Float ) = 4
        _FPS ("FPS", Float ) = 24
	}

	SubShader
	{
		Tags{}
		
		Pass
		{
			Tags {}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			sampler2D _Maintex; float4 _Maintex_ST;
			float _u;
			float _v;
			float _FPS;
			struct a2v { float4 vertex:POSITION; float2 texcoord:TEXCOORD0; };
			struct v2f { float4 pos:SV_POSITION; float2 uv:TEXCOORD0; };

			v2f vert(a2v i)
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, i.vertex);
				o.uv = i.texcoord;
				return o;
			}

			fixed4 frag(v2f v):SV_Target
			{
				float value = trunc(_FPS * _Time);
				float2 scale = float2(1/_u, -1/_v);
				float y = floor(value * scale.x);
				float x = value - y * _u;
				float2 uv = float2(v.uv.x + x, (1-v.uv.y) + y) * scale;
				fixed3 color = tex2D(_Maintex, uv).rgb;
				return fixed4(color, 1);
			}

			ENDCG
		}
	}
}