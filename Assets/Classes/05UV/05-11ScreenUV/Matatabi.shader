// Shader created with Shader Forge v1.26 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.26;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:0,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:5219,x:32877,y:32634,varname:node_5219,prsc:2|custl-7815-OUT;n:type:ShaderForge.SFN_Tex2d,id:3911,x:32514,y:32893,ptovrint:False,ptlb:MainTex,ptin:_MainTex,varname:_MainTex,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:b74d1a70c17be3644a5cc3ab57c971d8,ntxv:0,isnm:False|UVIN-4822-UVOUT;n:type:ShaderForge.SFN_TexCoord,id:4822,x:32327,y:32893,varname:node_4822,prsc:2,uv:0;n:type:ShaderForge.SFN_Tex2d,id:8374,x:32514,y:32715,ptovrint:False,ptlb:EffectTex,ptin:_EffectTex,varname:_EffectTex,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:83a577bd3444c9e4c908206655cb36c6,ntxv:0,isnm:False|UVIN-5293-UVOUT;n:type:ShaderForge.SFN_Tex2d,id:2656,x:32514,y:33071,ptovrint:False,ptlb:MaskTex,ptin:_MaskTex,varname:_MaskTex,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:0532da6c0a23cf1409afc696bb79efd7,ntxv:0,isnm:False|UVIN-4822-UVOUT;n:type:ShaderForge.SFN_Lerp,id:7815,x:32700,y:32873,varname:node_7815,prsc:2|A-8374-RGB,B-3911-RGB,T-2656-R;n:type:ShaderForge.SFN_ScreenPos,id:4198,x:32147,y:32717,varname:node_4198,prsc:2,sctp:0;n:type:ShaderForge.SFN_Panner,id:5293,x:32327,y:32717,varname:node_5293,prsc:2,spu:-0.5,spv:-0.5|UVIN-4198-UVOUT;proporder:3911-8374-2656;pass:END;sub:END;*/

Shader "Oboro/Matatabi" {
    Properties {
        _MainTex ("MainTex", 2D) = "white" {}
        _EffectTex ("EffectTex", 2D) = "white" {}
        _MaskTex ("MaskTex", 2D) = "white" {}
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
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform sampler2D _EffectTex; uniform float4 _EffectTex_ST;
            uniform sampler2D _MaskTex; uniform float4 _MaskTex_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 screenPos : TEXCOORD1;
                UNITY_FOG_COORDS(2)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                o.screenPos = o.pos;
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.screenPos = float4( i.screenPos.xy / i.screenPos.w, 0, 0 );
                //i.screenPos.y *= _ProjectionParams.x;
////// Lighting:
                float4 node_8665 = _Time + _TimeEditor;
                float2 node_5293 = (i.screenPos.rg+node_8665.g*float2(-0.5,-0.5));
                float4 _EffectTex_var = tex2D(_EffectTex,TRANSFORM_TEX(node_5293, _EffectTex));
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(i.uv0, _MainTex));
                float4 _MaskTex_var = tex2D(_MaskTex,TRANSFORM_TEX(i.uv0, _MaskTex));
                float3 finalColor = lerp(_EffectTex_var.rgb,_MainTex_var.rgb,_MaskTex_var.r);
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
