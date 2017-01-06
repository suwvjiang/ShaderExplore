// Shader created with Shader Forge v1.26 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.26;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:2293,x:32719,y:32712,varname:node_2293,prsc:2|custl-8109-RGB;n:type:ShaderForge.SFN_Tex2d,id:8109,x:32521,y:32951,ptovrint:False,ptlb:MainTex,ptin:_MainTex,varname:node_8109,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:9f8cb3ca3d06d0345a50ab575ce154ca,ntxv:0,isnm:False|UVIN-8921-UVOUT;n:type:ShaderForge.SFN_TexCoord,id:2933,x:32172,y:32943,varname:node_2933,prsc:2,uv:0;n:type:ShaderForge.SFN_Rotator,id:8921,x:32348,y:32943,varname:node_8921,prsc:2|UVIN-2933-UVOUT,ANG-5275-OUT;n:type:ShaderForge.SFN_Slider,id:6252,x:31681,y:33095,ptovrint:False,ptlb:Rotate,ptin:_Rotate,varname:node_6252,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:360;n:type:ShaderForge.SFN_Multiply,id:5143,x:32003,y:33095,varname:node_5143,prsc:2|A-6252-OUT,B-1803-OUT;n:type:ShaderForge.SFN_Pi,id:1803,x:31871,y:33168,varname:node_1803,prsc:2;n:type:ShaderForge.SFN_Divide,id:5275,x:32172,y:33095,varname:node_5275,prsc:2|A-5143-OUT,B-768-OUT;n:type:ShaderForge.SFN_Vector1,id:768,x:32003,y:33247,varname:node_768,prsc:2,v1:180;proporder:8109-6252;pass:END;sub:END;*/

Shader "Oboro/UVRotate" {
    Properties {
        _MainTex ("MainTex", 2D) = "white" {}
        _Rotate ("Rotate", Range(0, 360)) = 0
    }
    SubShader {
        Tags {
            "RenderType"="Opaque"
        }
        LOD 100
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma multi_compile_fog
            #pragma exclude_renderers gles3 metal d3d11_9x xbox360 xboxone ps3 ps4 psp2 
            #pragma target 3.0
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform float _Rotate;
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
                float node_8921_ang = ((_Rotate*3.141592654)/180.0);
                float node_8921_spd = 1.0;
                float node_8921_cos = cos(node_8921_spd*node_8921_ang);
                float node_8921_sin = sin(node_8921_spd*node_8921_ang);
                float2 node_8921_piv = float2(0.5,0.5);
                float2 node_8921 = (mul(i.uv0-node_8921_piv,float2x2( node_8921_cos, -node_8921_sin, node_8921_sin, node_8921_cos))+node_8921_piv);
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(node_8921, _MainTex));
                float3 finalColor = _MainTex_var.rgb;
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
