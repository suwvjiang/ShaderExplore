// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Shader created with Shader Forge v1.26 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.26;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:False,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:3863,x:32824,y:32574,varname:node_3863,prsc:2|custl-1484-OUT;n:type:ShaderForge.SFN_SceneColor,id:1847,x:32501,y:32833,varname:node_1847,prsc:2|UVIN-4224-OUT;n:type:ShaderForge.SFN_Multiply,id:1484,x:32664,y:32813,varname:node_1484,prsc:2|A-5267-OUT,B-1847-RGB;n:type:ShaderForge.SFN_Vector3,id:5267,x:32501,y:32738,varname:node_5267,prsc:2,v1:0.5,v2:0,v3:0;n:type:ShaderForge.SFN_Tex2d,id:3259,x:32015,y:32833,ptovrint:False,ptlb:FlowMap,ptin:_FlowMap,varname:node_3259,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:c1b38a07a3a28ac49bfb34dcfeae2381,ntxv:0,isnm:False|UVIN-1463-UVOUT;n:type:ShaderForge.SFN_Multiply,id:7920,x:32178,y:32833,varname:node_7920,prsc:2|A-1119-OUT,B-3259-R;n:type:ShaderForge.SFN_Slider,id:1119,x:31855,y:32731,ptovrint:False,ptlb:FlowIntensity,ptin:_FlowIntensity,varname:node_1119,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.05,max:0.1;n:type:ShaderForge.SFN_ScreenPos,id:1463,x:31571,y:33032,varname:node_1463,prsc:2,sctp:2;n:type:ShaderForge.SFN_Add,id:4224,x:32344,y:32833,varname:node_4224,prsc:2|A-7920-OUT,B-1463-UVOUT;proporder:3259-1119;pass:END;sub:END;*/

Shader "Oboro/Refraction01" {
    Properties {
        _FlowMap ("FlowMap", 2D) = "white" {}
        _FlowIntensity ("FlowIntensity", Range(0, 0.1)) = 0.05
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        LOD 100
        GrabPass{ }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
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
            uniform sampler2D _GrabTexture;
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
                o.pos = UnityObjectToClipPos(v.vertex );
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
                float4 sceneColor = tex2D(_GrabTexture, sceneUVs);
////// Lighting:
                float4 _FlowMap_var = tex2D(_FlowMap,TRANSFORM_TEX(sceneUVs.rg, _FlowMap));
                float3 finalColor = (float3(0.5,0,0)*tex2D( _GrabTexture, ((_FlowIntensity*_FlowMap_var.r)+sceneUVs.rg)).rgb);
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
