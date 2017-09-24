// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "UnityExplore/Reflection"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_ReflectionColor("Reflection Color", Color) = (1,1,1,1)
		_ReflectionAmount("Reflection Amount", Range(0, 1)) = 1
		_MainTex("MainTex", Cube) = "_Skybox" {}
	}
	SubShader
	{
		Name "Reflection"
		Tags {"RenderType"="Opaque" "Queue"="Geometry"}
		LOD 20

		Pass
		{
			Tags {"LightModel"="ForwardBase"}

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "Lighting.cginc"
			#include "AutoLight.cginc"

			fixed4 _Color;
			fixed4 _ReflectionColor;
			fixed _ReflectionAmount;
			samplerCUBE _MainTex;
			struct a2v {float4 vertex:POSITION; float3 normal:NORMAL; };
			struct v2f {float4 pos:SV_POSITION; float3 worldPos:TEXCOORD0; fixed3 worldNormal:TEXCOORD1; fixed3 worldReflect:TEXCOORD2 ; SHADOW_COORDS(3) };

			v2f vert(a2v i)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(i.vertex);
				o.worldPos = mul(unity_ObjectToWorld, i.vertex).xyz;
				o.worldNormal = UnityObjectToWorldNormal(i.normal);
				fixed3 worldView = UnityWorldSpaceViewDir(o.worldPos);
				o.worldReflect = reflect(-worldView, o.worldNormal);
				TRANSFER_SHADOW(o);
				return o;
			}

			fixed4 frag (v2f i):SV_Target
			{
				fixed3 normal = normalize(i.worldNormal);
				fixed3 lightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));

				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;
				fixed3 diffuseColor = _LightColor0.rgb * _Color.rgb * (0.5*dot(normal, lightDir) + 0.5);
				fixed3 reflection = texCUBE(_MainTex, i.worldReflect).rgb * _ReflectionColor.rgb;
				
				UNITY_LIGHT_ATTENUATION(atten, i, i.worldPos);

				fixed3 color = ambient + lerp(diffuseColor, reflection, _ReflectionAmount) * atten;

				return fixed4(color, 1);
			}

			ENDCG
		}
	}
	FallBack "Reflective/VertexLit"
}