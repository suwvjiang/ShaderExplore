Shader "Explore/VertexAnimation"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_CubeMap ("Texture", Cube) = "" {}
		_ReflectScale("Reflect Scale", Range(0, 1)) = 1
		_Magnitude("Distortion Magnitude", Float) = 1
		_Frequency("Distortion Frequency", Float) = 1
		_InvwaveLength("InvWave Length", Float) = 1
		_Speed("Speed", Float) = 1
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" "DisableBatching"="false"}
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
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
				float3 worldPos:TEXCOORD1;
				float3 normal:TEXCOORD2;
				float3 reflect:TEXCOORD3;
			};

			samplerCUBE _CubeMap;
			float4 _Color;
			float _ReflectScale;
			float _Magnitude;
			float _Frequency;
			float _InvwaveLength;
			float _Speed;
			
			v2f vert (a2v v)
			{
				float3 offset = v.normal;
				offset *= sin(_Time.y + v.vertex.y * _InvwaveLength + v.vertex.x * _InvwaveLength)*0.1+0.1;

				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex+offset);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
				o.normal = UnityObjectToWorldNormal(v.normal);
				float3 view = normalize(UnityWorldSpaceViewDir(o.worldPos));
				o.reflect = reflect(-view, o.normal);
				
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 refColor = texCUBE(_CubeMap, i.reflect);
				float4 col = lerp(_Color, refColor, _ReflectScale);
				return col;
			}
			ENDCG
		}
	}
}
