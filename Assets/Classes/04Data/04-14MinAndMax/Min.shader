// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Shader created with Shader Forge v1.26 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.26;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:0,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:4444,x:32650,y:32658,varname:node_4444,prsc:2|custl-8652-OUT;n:type:ShaderForge.SFN_Tex2d,id:1153,x:32178,y:32805,ptovrint:False,ptlb:Ramp01,ptin:_Ramp01,varname:node_1153,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:09d1ff494b66a6b4fa22b7183c7cd866,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Tex2d,id:369,x:32178,y:32991,ptovrint:False,ptlb:Ramp02,ptin:_Ramp02,varname:node_369,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:5d65250ade0d5ea41b93884a540a1f4f,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Min,id:8652,x:32461,y:32901,varname:node_8652,prsc:2|A-1153-R,B-369-R;n:type:ShaderForge.SFN_Max,id:8723,x:32461,y:33028,varname:node_8723,prsc:2|A-1153-R,B-369-R;proporder:1153-369;pass:END;sub:END;*/

Shader "Oboro/Min" {
    Properties {
        _Ramp01 ("Ramp01", 2D) = "white" {}
        _Ramp02 ("Ramp02", 2D) = "white" {}
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
            uniform sampler2D _Ramp01; uniform float4 _Ramp01_ST;
            uniform sampler2D _Ramp02; uniform float4 _Ramp02_ST;
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
                float4 _Ramp01_var = tex2D(_Ramp01,TRANSFORM_TEX(i.uv0, _Ramp01));
                float4 _Ramp02_var = tex2D(_Ramp02,TRANSFORM_TEX(i.uv0, _Ramp02));
                float node_8652 = min(_Ramp01_var.r,_Ramp02_var.r);
                float3 finalColor = float3(node_8652,node_8652,node_8652);
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
