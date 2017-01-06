Shader "UnityExplore/Diffuse Vertex-Level"
{
	Properties
	{
		_Diffuse("Diffuse", Color) = (1,1,1,1)
		_MainTex("MainTex", 2D) = "white" {}
	}
	
	SubShader
	{
		Pass
		{
			Tags {"LightMode"="ForwardBase"}
			
			CGPROGRAM
			
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			
			fixed4 _Diffuse;
			sampler2D _MainTex; fixed4 _MainTex_ST;
			
			struct a2v
			{
				float4 vertex:POSITION;
				float3 color:Color;
				float2 texcoord0 : TEXCOORD0;
			};
			
			struct v2f
			{
				float4 pos:SV_POSITION;
				float2 uv:TEXCOORD0;
			};
			
			v2f vert(a2v i)
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, i.vertex);
				o.uv = TRANSFORM_TEX(i.texcoord0, _MainTex);
				
				return o;
			}
			
			fixed4 frag(v2f i):SV_Target
			{
				fixed3 color = tex2D(_MainTex, i.uv).rgb;
				color *= _Diffuse.rgb;
				return fixed4(color, 1);
			}
			
			ENDCG
		}
	}
}