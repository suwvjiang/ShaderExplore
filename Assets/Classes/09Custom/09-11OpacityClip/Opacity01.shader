// Shader created with Shader Forge v1.26 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.26;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:0,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:0,dpts:2,wrdp:False,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:9331,x:33154,y:32458,varname:node_9331,prsc:2|custl-1055-OUT;n:type:ShaderForge.SFN_Tex2d,id:9990,x:32474,y:32587,ptovrint:False,ptlb:A,ptin:_A,varname:node_9990,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:2ea998858a8828947b3ef26108fad131,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Tex2d,id:1761,x:32474,y:32783,ptovrint:False,ptlb:B,ptin:_B,varname:node_1761,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:d1dc35a09a8cbe04ea9e9cc605801685,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Subtract,id:6446,x:32718,y:32698,varname:node_6446,prsc:2|A-9990-R,B-1761-R;n:type:ShaderForge.SFN_Multiply,id:1055,x:32941,y:32679,varname:node_1055,prsc:2|A-1982-OUT,B-6446-OUT;n:type:ShaderForge.SFN_Slider,id:1982,x:32663,y:32556,ptovrint:False,ptlb:Intensity,ptin:_Intensity,varname:node_1982,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:1,max:1;proporder:9990-1761-1982;pass:END;sub:END;*/

Shader "Oboro/Opacity01" {
    Properties {
        _A ("A", 2D) = "white" {}
        _B ("B", 2D) = "white" {}
        _Intensity ("Intensity", Range(0, 1)) = 1
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        LOD 100
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend One One
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma multi_compile_fog
            #pragma exclude_renderers gles3 metal d3d11_9x xbox360 xboxone ps3 ps4 psp2 
            #pragma target 3.0
            uniform sampler2D _A; uniform float4 _A_ST;
            uniform sampler2D _B; uniform float4 _B_ST;
            uniform float _Intensity;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                UNITY_FOG_COORDS(1)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
////// Lighting:
                float4 _A_var = tex2D(_A,TRANSFORM_TEX(i.uv0, _A));
                float4 _B_var = tex2D(_B,TRANSFORM_TEX(i.uv0, _B));
                float node_1055 = (_Intensity*(_A_var.r-_B_var.r));
                float3 finalColor = float3(node_1055,node_1055,node_1055);
                fixed4 finalRGBA = fixed4(finalColor,1);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
