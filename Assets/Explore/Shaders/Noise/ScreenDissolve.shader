Shader "Explore/ScreenDissolve"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="TransparntCutout" "Queue"="AlphaTest"}
		LOD 100

		CGINCLUDE
		#include "UnityCG.cginc"
			
		#define MOD3 float3(.1031,.11369,.13787)

		float3 fade(float3 f)
		{
			return f * f * f * (f * (f * 6.0 - 15.0) + 10.0);
		}

		float valueHashOld(float3 p)
		{
			float h = dot(p,float3(127.1,311.7, 74.7));
			
			return -1.0 + 2.0 * frac(sin(h)*43758.5453123);
		}

		float valueHash(float3 p)
		{
			p  = frac(p * MOD3);
    		p += dot(p, p.yzx + 19.19);
    		return - 1.0 + 2.0 * frac((p.x + p.y) * p.z);
		}

		float valueNoise(float3 p, float frequency)
		{
			p *= frequency;
			float3 i = floor(p);
			float3 f = frac(p);

			float3 u = fade(f);

			return lerp(lerp(lerp(valueHash(i + float3(0.0, 0.0, 0.0)), valueHash(i + float3(1.0, 0.0, 0.0)), u.x),
							 lerp(valueHash(i + float3(0.0, 1.0, 0.0)), valueHash(i + float3(1.0, 1.0, 0.0)), u.x), u.y), 
						lerp(lerp(valueHash(i + float3(0.0, 0.0, 1.0)), valueHash(i + float3(1.0, 0.0, 1.0)), u.x),
							 lerp(valueHash(i + float3(0.0, 1.0, 1.0)), valueHash(i + float3(1.0, 1.0, 1.0)), u.x), u.y), u.z);
		}

		float fbm(float3 p, int ocvate, float originFreq, float frequency, float originAmpl, float amplitude)
		{
			float total = 0;
			float num = 0;
			float freq = originFreq;
			float ampl = originAmpl;
			for(int i = 0; i < ocvate; ++i)
			{
				total += valueNoise(p, freq) * ampl;
				num += ampl;
				freq *= frequency;
				ampl *= amplitude;
			}
			return total / num;
		}
		ENDCG

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0

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
				float4 screen:TEXCOORD2;
				float4 roleScreen:TEXCOORD3;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _CameraDepthTexture;
			uniform float3 _RolePos;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
				o.screen = ComputeScreenPos(o.pos);
				COMPUTE_EYEDEPTH(o.screen.z);

				float4 rolePos = UnityWorldToClipPos(_RolePos);
				o.roleScreen = ComputeScreenPos(rolePos);
				o.roleScreen.z = -UnityWorldToViewPos(_RolePos).z;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float noise = fbm(i.worldPos, 2, 1, 2, 1, 0.5);
				noise = noise * 0.5 + 0.5;
				// sample the texture
				float2 uv = i.screen.xy/i.screen.w;
				fixed mask = tex2D(_MainTex, uv).r;
				//noise *= mask;

				float2 roleUV = i.roleScreen.xy / i.roleScreen.w;
				float dis = distance(uv, roleUV);

				float depth = i.screen.z;
				float roleDepth = i.roleScreen.z;
				depth = (roleDepth - depth)/roleDepth;

				dis = dis - noise * depth * mask;
				clip(dis);

				return fixed4(mask, mask, mask, 1);
			}
			ENDCG
		}
	}
	Fallback "Transparent/Cutout/VertexLit"
}
