// Shader created with Shader Forge v1.26 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.26;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:0,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:1109,x:32719,y:32712,varname:node_1109,prsc:2|custl-5113-RGB;n:type:ShaderForge.SFN_Tex2d,id:5113,x:32520,y:32954,ptovrint:False,ptlb:MainTex,ptin:_MainTex,varname:_MainTex,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:3a9827e5c0fbc6e47826a509282e99a4,ntxv:0,isnm:False|UVIN-4720-OUT;n:type:ShaderForge.SFN_Time,id:7338,x:31802,y:33011,varname:node_7338,prsc:2;n:type:ShaderForge.SFN_Multiply,id:731,x:31977,y:32952,varname:node_731,prsc:2|A-4955-OUT,B-7338-T;n:type:ShaderForge.SFN_Multiply,id:6863,x:31977,y:33103,varname:node_6863,prsc:2|A-7338-T,B-1128-OUT;n:type:ShaderForge.SFN_Append,id:2321,x:32150,y:33028,varname:node_2321,prsc:2|A-731-OUT,B-6863-OUT;n:type:ShaderForge.SFN_TexCoord,id:8741,x:31977,y:32808,varname:node_8741,prsc:2,uv:0;n:type:ShaderForge.SFN_Add,id:4720,x:32348,y:32954,varname:node_4720,prsc:2|A-8741-UVOUT,B-2321-OUT;n:type:ShaderForge.SFN_Slider,id:1128,x:31645,y:33160,ptovrint:False,ptlb:VSpeed,ptin:_VSpeed,varname:_VSpeed,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:-0.2,cur:0,max:0.2;n:type:ShaderForge.SFN_Slider,id:4955,x:31645,y:32925,ptovrint:False,ptlb:USpeed,ptin:_USpeed,varname:_USpeed,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:-0.2,cur:0,max:0.2;proporder:5113-4955-1128;pass:END;sub:END;*/

Shader "Oboro/UVOffset" {
    Properties {
        _MainTex ("MainTex", 2D) = "white" {}
        _USpeed ("USpeed", Range(-0.2, 0.2)) = 0
        _VSpeed ("VSpeed", Range(-0.2, 0.2)) = 0
    }
    SubShader {
        Tags {
            "RenderType"="Opaque"
        }
        LOD 200
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
            uniform float4 _TimeEditor;
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform float _VSpeed;
            uniform float _USpeed;
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
                float4 node_7338 = _Time + _TimeEditor;
                float2 node_4720 = (i.uv0+float2((_USpeed*node_7338.g),(node_7338.g*_VSpeed)));
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(node_4720, _MainTex));
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
