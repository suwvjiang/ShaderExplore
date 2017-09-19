Shader "Explore/ForceField"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_Amount("Amount", Range(0, 1)) = 0.5
		_Depth("Depth", Range(0, 1)) = 0.2
		_IntersectPower("Intersect Power", Range(0, 8)) = 2
		_NoiseTex("Noise Tex", 2D) = ""{}
		_DisTimeFactor("Time Factor", Range(0,1)) = 0.5
		_DisWidth("Dis Width", Range(0, 1)) = 0.5
	}
	SubShader
	{
		Tags { "RenderType"="Transparent" "Queue"="Transparent" }
		LOD 100
		Blend SrcAlpha OneMinusSrcAlpha
		ZWrite Off Cull Off

		GrabPass{"_FieldTexture"}
		CGINCLUDE

		#include "UnityCG.cginc"

		struct a2v
		{
			float4 vertex : POSITION;
			float2 uv : TEXCOORD0;
			float3 normal:NORMAL;
		};

		struct v2f
		{
			float4 pos : SV_POSITION;
			float2 uv : TEXCOORD0;
			float3 normalW:TEXCOORD1;
			float3 viewW:TEXCOORD2;
			float4 proj:TEXCOORD3;
			float4 screenPos:TEXCOORD4;
		};

		sampler2D _NoiseTex; float4 _NoiseTex_ST;
		sampler2D _CameraDepthTexture;
		sampler2D _FieldTexture;
		half4 _Color;
		half _Amount;
		half _Depth;
		half _IntersectPower;
		half _DisTimeFactor;
		half _DisWidth;
		
		v2f vert (a2v v)
		{
			v2f o;
			o.pos = UnityObjectToClipPos(v.vertex);
			o.uv = TRANSFORM_TEX(v.uv, _NoiseTex);
			float3 posW = mul(unity_ObjectToWorld, v.vertex);
			o.normalW = normalize(UnityObjectToWorldNormal(v.normal));
			o.viewW = normalize(UnityWorldSpaceViewDir(posW));
			o.proj = ComputeScreenPos(o.pos);
			COMPUTE_EYEDEPTH(o.proj.z);
			o.screenPos = ComputeGrabScreenPos(o.pos);
			return o;
		}
		
		fixed4 frag (v2f i) : SV_Target
		{
			half3 normal = normalize(i.normalW);
			half3 view = normalize(i.viewW);
			float2 uv = i.proj.xy/i.proj.w;
			float depth = LinearEyeDepth(tex2D(_CameraDepthTexture, uv).r);
			float offset = depth - i.proj.z;

			half nv = abs(dot(normal, view));
			half rim = (1 - nv) * _Amount;
			half intersect = pow((_Depth-offset), _IntersectPower);
			half4 color = _Color * max(rim, intersect);

			fixed2 noise = tex2D(_NoiseTex, i.uv + _Time.xy * _DisTimeFactor).xy * _DisWidth;
			i.screenPos.xy += noise;
			half4 field = tex2Dproj(_FieldTexture, i.screenPos);
//			color += field;

			return color;
		}

		v2f vertGrab(a2v v)
		{
			v2f o;
			o.pos = UnityObjectToClipPos(v.vertex);
			o.uv = TRANSFORM_TEX(v.uv, _NoiseTex);
			o.screenPos = ComputeGrabScreenPos(o.pos);
			return o;
		}

		fixed4 fragGrab(v2f i):SV_Target
		{
			fixed2 noise = tex2D(_NoiseTex, i.uv + _Time.xy * _DisTimeFactor).xy * _DisWidth;
			i.screenPos.xy += noise;
			half4 field = tex2Dproj(_FieldTexture, i.screenPos);
			return fixed4(field.rgb, 1);
		}
		ENDCG

		Pass
		{
			CGPROGRAM
			#pragma vertex vertGrab
			#pragma fragment fragGrab
			ENDCG
		}

		Pass
		{

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			ENDCG
		}
	}
}
