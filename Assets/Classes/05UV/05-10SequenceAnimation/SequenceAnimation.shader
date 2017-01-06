// Shader created with Shader Forge v1.26 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.26;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:1935,x:32949,y:32990,varname:node_1935,prsc:2|custl-5903-RGB;n:type:ShaderForge.SFN_Tex2d,id:5903,x:32770,y:33231,varname:node_5903,prsc:2,tex:542e63eb6e518e74ea3f102ee8d82a98,ntxv:0,isnm:False|UVIN-563-UVOUT,TEX-5675-TEX;n:type:ShaderForge.SFN_UVTile,id:563,x:32592,y:33231,varname:node_563,prsc:2|UVIN-181-OUT,WDT-3313-OUT,HGT-7075-OUT,TILE-2456-OUT;n:type:ShaderForge.SFN_TexCoord,id:9038,x:32056,y:33102,varname:node_9038,prsc:2,uv:0;n:type:ShaderForge.SFN_ValueProperty,id:3313,x:32225,y:33343,ptovrint:False,ptlb:u,ptin:_u,varname:node_3313,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:4;n:type:ShaderForge.SFN_ValueProperty,id:7974,x:32226,y:33425,ptovrint:False,ptlb:v,ptin:_v,varname:node_7974,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:4;n:type:ShaderForge.SFN_Tex2dAsset,id:5675,x:32592,y:33384,ptovrint:False,ptlb:Maintex,ptin:_Maintex,varname:node_5675,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:542e63eb6e518e74ea3f102ee8d82a98,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Trunc,id:2456,x:32397,y:33576,varname:node_2456,prsc:2|IN-8465-OUT;n:type:ShaderForge.SFN_RemapRange,id:7530,x:32225,y:33158,varname:node_7530,prsc:2,frmn:0,frmx:1,tomn:1,tomx:0|IN-9038-V;n:type:ShaderForge.SFN_Append,id:181,x:32386,y:33122,varname:node_181,prsc:2|A-9038-U,B-7530-OUT;n:type:ShaderForge.SFN_Negate,id:7075,x:32397,y:33425,varname:node_7075,prsc:2|IN-7974-OUT;n:type:ShaderForge.SFN_Time,id:4538,x:32064,y:33556,varname:node_4538,prsc:2;n:type:ShaderForge.SFN_Multiply,id:8465,x:32236,y:33576,varname:node_8465,prsc:2|A-4538-T,B-9599-OUT;n:type:ShaderForge.SFN_ValueProperty,id:9599,x:32064,y:33701,ptovrint:False,ptlb:FPS,ptin:_FPS,varname:node_9599,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:24;proporder:5675-3313-7974-9599;pass:END;sub:END;*/

Shader "Oboro/SequenceAnimation" {
    Properties {
        _Maintex ("Maintex", 2D) = "white" {}
        _u ("u", Float ) = 4
        _v ("v", Float ) = 4
        _FPS ("FPS", Float ) = 24
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
            uniform float4 _TimeEditor;
            uniform float _u;
            uniform float _v;
            uniform sampler2D _Maintex; uniform float4 _Maintex_ST;
            uniform float _FPS;
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
                float4 node_4538 = _Time + _TimeEditor;
                float node_2456 = trunc((node_4538.g*_FPS));
                float2 node_563_tc_rcp = float2(1.0,1.0)/float2( _u, (-1*_v) );
                float node_563_ty = floor(node_2456 * node_563_tc_rcp.x);
                float node_563_tx = node_2456 - _u * node_563_ty;
                float2 node_563 = (float2(i.uv0.r,(i.uv0.g*-1.0+1.0)) + float2(node_563_tx, node_563_ty)) * node_563_tc_rcp;
                float4 node_5903 = tex2D(_Maintex,TRANSFORM_TEX(node_563, _Maintex));
                float3 finalColor = node_5903.rgb;
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
