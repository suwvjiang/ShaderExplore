// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Shader created with Shader Forge v1.26 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.26;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:0,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:9887,x:33073,y:32679,varname:node_9887,prsc:2|custl-41-RGB;n:type:ShaderForge.SFN_TexCoord,id:6382,x:32049,y:32913,varname:node_6382,prsc:2,uv:0;n:type:ShaderForge.SFN_RemapRange,id:4288,x:32215,y:32913,varname:node_4288,prsc:2,frmn:0,frmx:1,tomn:-1,tomx:1|IN-6382-UVOUT;n:type:ShaderForge.SFN_Length,id:933,x:32394,y:32814,varname:node_933,prsc:2|IN-4288-OUT;n:type:ShaderForge.SFN_ComponentMask,id:9619,x:32394,y:32966,varname:node_9619,prsc:2,cc1:0,cc2:1,cc3:-1,cc4:-1|IN-4288-OUT;n:type:ShaderForge.SFN_ArcTan2,id:8074,x:32559,y:32986,varname:node_8074,prsc:2,attp:2|A-9619-R,B-9619-G;n:type:ShaderForge.SFN_Append,id:5106,x:32723,y:32919,varname:node_5106,prsc:2|A-933-OUT,B-8074-OUT;n:type:ShaderForge.SFN_Tex2d,id:41,x:32888,y:32919,ptovrint:False,ptlb:MainTex,ptin:_MainTex,varname:node_41,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:c6e1cf1d30253334897e1a5e4340b02a,ntxv:0,isnm:False|UVIN-5106-OUT;proporder:41;pass:END;sub:END;*/

Shader "Oboro/PolarCoordinates" {
    Properties {
        _MainTex ("MainTex", 2D) = "white" {}
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
                float2 node_4288 = (i.uv0*2.0+-1.0);
                float2 node_9619 = node_4288.rg;
                float2 node_5106 = float2(length(node_4288),((atan2(node_9619.r,node_9619.g)/6.28318530718)+0.5));
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(node_5106, _MainTex));
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
