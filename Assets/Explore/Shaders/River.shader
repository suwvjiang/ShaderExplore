// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Explore/River"
{
	Properties
	{
		_MainTex ("MainTex", 2D) = "white" {}
        _FlowMap ("FlowMap", 2D) = "white" {}
        _AlphaMap ("AlphaMap", 2D) = "white" {}
        _Alpha ("Alpha", Range(0, 1)) = 0.5
        _FlowIntensity ("FlowIntensity", Float ) = 0.01
        _USpeed ("USpeed", Float ) = 1
        _VSpeed ("VSpeed", Float ) = 0
        _TexSpeed ("TexSpeed", Float ) = -0.5
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
	}

	SubShader
	{
		Tags {"IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"}

		Pass
		{
			Name "BASE"
			Tags { "LightMode"="ForwardBase" }
			Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#pragma multi_compile_fwdbase
			#define UNITY_PASS_FORWARDBASE

			sampler2D _MainTex; float4 _MainTex_ST;
			sampler2D _FlowMap; float4 _FlowMap_ST;
			sampler2D _AlphaMap; float4 _AlphaMap_ST;
			float _Alpha;
			float _FlowIntensity;
			float _USpeed;
			float _VSpeed;
			float _TexSpeed;
			float _Cutoff;

			struct a2v { float4 vertex : POSITION; float2 texcoord0:TEXCOORD0; float2 texcoord1:TEXCOORD1; };
			struct v2f { float4 pos:SV_POSITION; float2 uv:TEXCOORD0; float2 uv1:TEXCOORD1; };

			v2f vert(a2v i)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(i.vertex);
				o.uv = i.texcoord0;
				o.uv1 = i.texcoord1;
				return o;
			}

			fixed4 frag(v2f v):SV_Target
			{
				float2 offset = float2(_USpeed, _VSpeed) * _Time.g;
				float2 flowuv = v.uv + offset;
				float2 uvoff = tex2D(_FlowMap, TRANSFORM_TEX(flowuv, _FlowMap)).xy;
				float2 uv = v.uv + uvoff * _FlowIntensity + _TexSpeed * offset;
				fixed4 color = tex2D(_MainTex, TRANSFORM_TEX(uv, _MainTex));
				color.a *= tex2D(_AlphaMap, TRANSFORM_TEX(v.uv1, _AlphaMap)).r * _Alpha;

				return color;
			}

			ENDCG
		}
	}
}