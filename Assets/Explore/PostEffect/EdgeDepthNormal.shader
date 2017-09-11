Shader "Explore/EdgeDepthNormal"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_EdgeOnly("Edge Only", Float) = 1.0
		_EdgeColor("Edge Color", Color) = (1,1,1,1)
		_BackgroundColor("Background Color", Color) = (0,0,0,0)
		_SampleDistance("SampleDistance", Float) = 1.0
		_Sensitivity("Sensitivity", Vector) = (1,1,1,1)
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100
		CGINCLUDE
		#include "UnityCG.cginc"

		struct a2v
		{
			float4 vertex : POSITION;
			float2 uv : TEXCOORD0;
		};

		struct v2f
		{
			float4 pos : SV_POSITION;
			half2 uv[5] : TEXCOORD0;
		};

		sampler2D _MainTex;
		float4 _MainTex_TexelSize;
		sampler2D _CameraDepthNormalsTexture;
		float4 _EdgeColor;
		float4 _BackgroundColor;
		float4 _Sensitivity;
		float _EdgeOnly;
		float _SampleDistance;
		
		half CheckSame(half4 a, half4 b)
		{
			half depthA;
			half3 normalA;
			half depthB; 
			half3 normalB;
			DecodeDepthNormal(a, depthA, normalA);
			DecodeDepthNormal(b, depthB, normalB);

			half3 Gn = abs(normalA - normalB) * _Sensitivity.x;
			int normalSame = (Gn.x + Gn.y + Gn.z) < 0.1;

			half Gd = abs(depthA - depthB) * _Sensitivity.y;
			int depthSame = Gd < 0.1;

			return depthSame * normalSame ? 1.0 : 0.0;
		}

		v2f vert (a2v v)
		{
			v2f o;
			o.pos = UnityObjectToClipPos(v.vertex);
			half2 uv = v.uv;
			o.uv[0] = uv;

			#if UNITY_UV_STARTS_AT_TOP
			if(_MainTex_TexelSize.y < 0)
				uv.y = 1-uv.y;
			#endif
			//Roberts
			half2 offset = _MainTex_TexelSize.xy * _SampleDistance;
			o.uv[1] = uv + offset * half2(1, 1);
			o.uv[2] = uv + offset * half2(-1, -1);
			o.uv[3] = uv + offset * half2(-1, 1);
			o.uv[4] = uv + offset * half2(1, -1);
			return o;
		}
		
		fixed4 frag (v2f i) : SV_Target
		{
			// sample the texture
			fixed4 albedo = tex2D(_MainTex, i.uv[0]);
			half4 samp = tex2D(_CameraDepthNormalsTexture, i.uv[0]);
			half4 sample1 = tex2D(_CameraDepthNormalsTexture, i.uv[1]);
			half4 sample2 = tex2D(_CameraDepthNormalsTexture, i.uv[2]);
			half4 sample3 = tex2D(_CameraDepthNormalsTexture, i.uv[3]);
			half4 sample4 = tex2D(_CameraDepthNormalsTexture, i.uv[4]);

			half edge = 1.0;
			int check1 = CheckSame(sample1, sample2);
			int check2 = CheckSame(sample3, sample4);
			edge *= check1;
			edge *= check2;

			fixed4 withEdgeColor = lerp(_EdgeColor, albedo, edge);
			fixed4 onlyEdgeColor = lerp(_EdgeColor, _BackgroundColor, edge);
			return lerp(withEdgeColor, onlyEdgeColor, _EdgeOnly);
		}
		ENDCG

		Pass
		{
			ZTest Always ZWrite Off Cull Off
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			ENDCG
		}
	}
}
