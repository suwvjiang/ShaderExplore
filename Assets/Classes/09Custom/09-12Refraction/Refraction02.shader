// Shader created with Shader Forge v1.26 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.26;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:0,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:3,bdst:7,dpts:2,wrdp:False,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:231,x:32801,y:32693,varname:node_231,prsc:2|custl-2351-RGB,alpha-2351-A;n:type:ShaderForge.SFN_Tex2d,id:2351,x:32634,y:32931,ptovrint:False,ptlb:RenderTex,ptin:_RenderTex,varname:node_2351,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:bebf42c7f09def945a3174997202d564,ntxv:0,isnm:False|UVIN-4265-OUT;n:type:ShaderForge.SFN_ScreenPos,id:5002,x:31472,y:32915,varname:node_5002,prsc:2,sctp:2;n:type:ShaderForge.SFN_Append,id:2886,x:31800,y:32934,varname:node_2886,prsc:2|A-5002-U,B-3715-OUT;n:type:ShaderForge.SFN_Tex2d,id:2097,x:32145,y:32964,ptovrint:False,ptlb:FlowMap,ptin:_FlowMap,varname:node_2097,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:c1b38a07a3a28ac49bfb34dcfeae2381,ntxv:0,isnm:False|UVIN-2872-UVOUT;n:type:ShaderForge.SFN_Panner,id:2872,x:31975,y:32964,varname:node_2872,prsc:2,spu:0.3,spv:0.3|UVIN-2886-OUT;n:type:ShaderForge.SFN_Multiply,id:538,x:32306,y:32981,varname:node_538,prsc:2|A-2097-R,B-7692-OUT;n:type:ShaderForge.SFN_Slider,id:7692,x:31988,y:33137,ptovrint:False,ptlb:FlowIntensity,ptin:_FlowIntensity,varname:node_7692,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.03,max:0.1;n:type:ShaderForge.SFN_Add,id:4265,x:32467,y:32931,varname:node_4265,prsc:2|A-2886-OUT,B-538-OUT;n:type:ShaderForge.SFN_OneMinus,id:3715,x:31634,y:32977,varname:node_3715,prsc:2|IN-5002-V;proporder:2351-2097-7692;pass:END;sub:END;*/

Shader "Oboro/Refraction02" {
    Properties {
        _RenderTex ("RenderTex", 2D) = "white" {}
        _FlowMap ("FlowMap", 2D) = "white" {}
        _FlowIntensity ("FlowIntensity", Range(0, 0.1)) = 0.03
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
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
            Blend SrcAlpha OneMinusSrcAlpha
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
            uniform float4 _TimeEditor;
            uniform sampler2D _RenderTex; uniform float4 _RenderTex_ST;
            uniform sampler2D _FlowMap; uniform float4 _FlowMap_ST;
            uniform float _FlowIntensity;
            struct VertexInput {
                float4 vertex : POSITION;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float4 screenPos : TEXCOORD0;
                UNITY_FOG_COORDS(1)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                o.screenPos = o.pos;
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                #if UNITY_UV_STARTS_AT_TOP
                    float grabSign = -_ProjectionParams.x;
                #else
                    float grabSign = _ProjectionParams.x;
                #endif
                i.screenPos = float4( i.screenPos.xy / i.screenPos.w, 0, 0 );
                i.screenPos.y *= _ProjectionParams.x;
                float2 sceneUVs = float2(1,grabSign)*i.screenPos.xy*0.5+0.5;
////// Lighting:
                float2 node_2886 = float2(sceneUVs.r,(1.0 - sceneUVs.g));
                float4 node_6026 = _Time + _TimeEditor;
                float2 node_2872 = (node_2886+node_6026.g*float2(0.3,0.3));
                float4 _FlowMap_var = tex2D(_FlowMap,TRANSFORM_TEX(node_2872, _FlowMap));
                float2 node_4265 = (node_2886+(_FlowMap_var.r*_FlowIntensity));
                float4 _RenderTex_var = tex2D(_RenderTex,TRANSFORM_TEX(node_4265, _RenderTex));
                float3 finalColor = _RenderTex_var.rgb;
                fixed4 finalRGBA = fixed4(finalColor,_RenderTex_var.a);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
