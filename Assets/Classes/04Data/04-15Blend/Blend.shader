// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Shader created with Shader Forge v1.26 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.26;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0,fgcg:1,fgcb:0.5862069,fgca:1,fgde:0.01,fgrn:0,fgrf:136.53,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:2729,x:32636,y:32686,varname:node_2729,prsc:2|custl-6703-OUT;n:type:ShaderForge.SFN_Tex2d,id:2215,x:32258,y:32786,ptovrint:False,ptlb:MainTex01,ptin:_MainTex01,varname:node_2215,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:337dbccf2aa9b1a41b17818683a8e40e,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Tex2d,id:9290,x:32258,y:33039,ptovrint:False,ptlb:MainTex02,ptin:_MainTex02,varname:node_9290,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:42f72ed525a36164ea0a4fd21ce09af3,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Blend,id:6703,x:32444,y:32924,varname:node_6703,prsc:2,blmd:1,clmp:True|SRC-2215-RGB,DST-9290-RGB;proporder:2215-9290;pass:END;sub:END;*/

Shader "Oboro/Blend" {
    Properties {
        _MainTex01 ("MainTex01", 2D) = "white" {}
        _MainTex02 ("MainTex02", 2D) = "white" {}
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
            uniform sampler2D _MainTex01; uniform float4 _MainTex01_ST;
            uniform sampler2D _MainTex02; uniform float4 _MainTex02_ST;
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
                float4 _MainTex01_var = tex2D(_MainTex01,TRANSFORM_TEX(i.uv0, _MainTex01));
                float4 _MainTex02_var = tex2D(_MainTex02,TRANSFORM_TEX(i.uv0, _MainTex02));
                float3 finalColor = saturate((_MainTex01_var.rgb*_MainTex02_var.rgb));
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
