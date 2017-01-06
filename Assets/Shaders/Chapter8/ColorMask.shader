Shader "Custom/ColorMask" 
{
    Properties 
	{
        //定义一个贴图
        _MainTex ("Base (RGB)", 2D) = "white" {} 
    }
	/*
    SubShader 
    {       
        Tags {"RenderType" = "Opaque" "IGNOREPROJECTOR" = "TRUE" "QUEUE" = "Transparent"}
        LOD 200

		Pass
        {
            Blend One OneMinusSrcAlpha
			ColorMask RGBA

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			sampler2D _MainTex;
			fixed4 _MainTex_ST;

			struct a2v
			{
				fixed4 vertex:POSITION;
				fixed4 texcoord:TEXCOORD0;
			};
            
			struct v2f
			{ 
				fixed4 pos:SV_POSITION;
				fixed2 uv:TEXCOORD0;
			};

			v2f vert(a2v v)
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);

				return o;
			}

			fixed4 frag(v2f v):SV_Target
			{
				fixed4 color = tex2D(_MainTex, v.uv);

				return color;
			}

			ENDCG
        }

    } 
	*/

	Category 
	{
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
		Blend SrcAlpha One
		Cull Off 
		Lighting Off 
		ZWrite Off 
		Fog { Color (0,0,0,0) }
		ColorMask RGB
		
		BindChannels 
		{
			Bind "Color", color
			Bind "Vertex", vertex
			Bind "TexCoord", texcoord
		}
		
		SubShader 
		{
			Pass 
			{
				SetTexture [_MainTex] 
				{
					combine texture * primary
				}
			}
		}
	}
    FallBack "Diffuse"
}