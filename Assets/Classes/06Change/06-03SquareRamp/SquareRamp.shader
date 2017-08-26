// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Shader created with Shader Forge v1.26 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.26;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:0,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:1750,x:33685,y:32537,varname:node_1750,prsc:2|custl-9057-OUT;n:type:ShaderForge.SFN_TexCoord,id:8671,x:32531,y:32776,varname:node_8671,prsc:2,uv:0;n:type:ShaderForge.SFN_RemapRange,id:256,x:32693,y:32776,varname:node_256,prsc:2,frmn:0,frmx:1,tomn:-1,tomx:1|IN-8671-UVOUT;n:type:ShaderForge.SFN_Abs,id:4070,x:32861,y:32776,varname:node_4070,prsc:2|IN-256-OUT;n:type:ShaderForge.SFN_OneMinus,id:8017,x:33015,y:32776,varname:node_8017,prsc:2|IN-4070-OUT;n:type:ShaderForge.SFN_ComponentMask,id:3020,x:33174,y:32776,varname:node_3020,prsc:2,cc1:0,cc2:1,cc3:-1,cc4:-1|IN-8017-OUT;n:type:ShaderForge.SFN_Min,id:341,x:33347,y:32776,varname:node_341,prsc:2|A-3020-R,B-3020-G;n:type:ShaderForge.SFN_Step,id:9057,x:33513,y:32776,varname:node_9057,prsc:2|A-341-OUT,B-6704-OUT;n:type:ShaderForge.SFN_Slider,id:6704,x:33190,y:32943,ptovrint:False,ptlb:Step,ptin:_Step,varname:node_6704,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.5,max:1;proporder:6704;pass:END;sub:END;*/

Shader "Oboro/SquareRamp" {
    Properties {
        _Step ("Step", Range(0, 1)) = 0.5
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
            uniform float _Step;
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
                o.pos = UnityObjectToClipPos(v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
////// Lighting:
                float2 node_3020 = (1.0 - abs((i.uv0*2.0+-1.0))).rg;
                float node_9057 = step(min(node_3020.r,node_3020.g),_Step);
                float3 finalColor = float3(node_9057,node_9057,node_9057);
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
