Shader "Custom/AlphaTestWithShadow" 
{
	Properties 
	{
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Cutoff ("AlphaCutoff", Range(0,1)) = 0.5
	}
	SubShader 
	{
		Pass
		{
			Tags {""=""}

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "Lighting.cginc"
			#include "AutoLight.cginc"

			fixed4 _Color;
			sampler2D _MainTex;
			fixed4 _MainTex_ST;
			float _Cutoff;

			struct a2v
			{
				fixed4 vertex:POSITION;
				fixed3 normal:NORMAL;
				fixed4 texcoord:TEXCOORD0;
			};

			struct v2f
			{
				fixed4 pos:SV_POSITION;
				fixed3 worldNormal:TEXCOORD0;
				fixed3 worldPos:TEXCOORD1;
				float2 uv:TEXCOORD2;
				SHADOW_COORDS(3)
			};

			v2f vert(a2v v)
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.worldNormal = mul(v.normal, (float3x3)_World2Object);
				o.worldPos = mul(_Object2World, v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				TRANSFER_SHADOW(o);
				return o;
			}

			fixed4 frag(v2f v):SV_Target
			{
				fixed3 worldNormal = normalize(v.worldNormal);
				fixed3 worldLight = normalize(UnityWorldSpaceLightDir(v.worldPos));
				
				fixed4 color = tex2D(_MainTex, v.uv);

				clip(color.a - _Cutoff);

				fixed3 albedo = color.rgb * _Color.rgb;
				fixed3 diffuse = _LightColor0.rgb * albedo * max(0, dot(worldNormal, worldLight));

				UNITY_LIGHT_ATTENUATION(atten, v, v.worldPos);

				return fixed4(diffuse*atten, 1.0);
			}

			ENDCG
		}

		// Pass to render object as a shadow caster
		Pass 
		{
			Name "Caster"
			Tags { "LightMode" = "ShadowCaster" }
		
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_shadowcaster

			#include "UnityCG.cginc"
			
			fixed4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed _Cutoff;

			struct v2f 
			{ 
				V2F_SHADOW_CASTER;
				float2  uv : TEXCOORD1;
			};

			v2f vert( appdata_base v )
			{
				v2f o;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				return o;
			}

			float4 frag( v2f i ) : SV_Target
			{
				fixed4 texcol = tex2D( _MainTex, i.uv );
				clip( texcol.a*_Color.a - _Cutoff );
			
				SHADOW_CASTER_FRAGMENT(i)
			}
			ENDCG

		}
	}
}
