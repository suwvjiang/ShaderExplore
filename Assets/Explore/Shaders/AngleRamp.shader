// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Explore/AngleRamp" 
{
     Properties 
     {
          _MainTex ("MainTex", 2D) = "white" {}
     }
     SubShader 
     {
          Tags {}
          Pass
          {
               Tags {}

               CGPROGRAM
               #pragma vertex vert
               #pragma fragment frag
               #include "UnityCG.cginc"

               sampler2D _MainTex; float4 _MainTex_ST;
               struct a2v {float4 vertex:POSITION; float2 texcoord:TEXCOORD0; };
               struct v2f {float4 pos:SV_POSITION; float2 uv:TEXCOORD0; };

               v2f vert(a2v i)
               {
                    v2f o;
                    o.pos = UnityObjectToClipPos(i.vertex);
                    o.uv = i.texcoord;

                    return o;
               }

               fixed4 frag(v2f v):SV_Target
               {
                    float2 uv = v.uv * 2 - 1;
                    float len = length(uv);
                    float value = atan2(uv.x, uv.y)/6.28318530718;
                    float2 texcoord = float2(len, 0);

                    float3 finalColor = tex2D(_MainTex, texcoord);
                    return fixed4(finalColor,1);
               }
               ENDCG
          }
     } 
     FallBack "Diffuse"
}

