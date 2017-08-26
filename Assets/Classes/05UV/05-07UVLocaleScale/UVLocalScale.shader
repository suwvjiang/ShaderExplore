// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Shader created with Shader Forge v1.26 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.26;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:0,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:4480,x:32719,y:32712,varname:node_4480,prsc:2|custl-3201-RGB;n:type:ShaderForge.SFN_Tex2d,id:3201,x:32536,y:32953,ptovrint:False,ptlb:MainTex,ptin:_MainTex,varname:_MainTex,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:5f5e820e552b9f147b83a7b6dd67dbbb,ntxv:0,isnm:False|UVIN-6609-OUT;n:type:ShaderForge.SFN_TexCoord,id:3398,x:31702,y:32947,varname:node_3398,prsc:2,uv:0;n:type:ShaderForge.SFN_Add,id:6609,x:32368,y:32953,varname:node_6609,prsc:2|A-3398-UVOUT,B-3553-OUT;n:type:ShaderForge.SFN_Slider,id:4701,x:31853,y:33296,ptovrint:False,ptlb:Scale,ptin:_Scale,varname:_Scale,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:-4,cur:0,max:4;n:type:ShaderForge.SFN_Tex2d,id:4802,x:32010,y:33110,ptovrint:False,ptlb:ScaleTex,ptin:_ScaleTex,varname:_ScaleTex,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:3a5a96df060a5cf4a9cc0c59e13486b7,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Add,id:6013,x:32010,y:32971,varname:node_6013,prsc:2|A-3398-UVOUT,B-8158-OUT;n:type:ShaderForge.SFN_Vector1,id:8158,x:31839,y:32991,varname:node_8158,prsc:2,v1:-0.5;n:type:ShaderForge.SFN_Multiply,id:3553,x:32199,y:32971,varname:node_3553,prsc:2|A-6013-OUT,B-4802-R,C-4701-OUT;proporder:3201-4802-4701;pass:END;sub:END;*/

Shader "Oboro/UVLocalScale" {
    Properties {
        _MainTex ("MainTex", 2D) = "white" {}
        _ScaleTex ("ScaleTex", 2D) = "white" {}
        _Scale ("Scale", Range(-4, 4)) = 0
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
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform float _Scale;
            uniform sampler2D _ScaleTex; uniform float4 _ScaleTex_ST;
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
                float4 _ScaleTex_var = tex2D(_ScaleTex,TRANSFORM_TEX(i.uv0, _ScaleTex));
                float2 node_6609 = i.uv0 + (i.uv0-0.5)*_ScaleTex_var.r * _Scale;
                
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(node_6609, _MainTex));
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
