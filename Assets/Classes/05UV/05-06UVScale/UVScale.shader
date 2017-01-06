// Shader created with Shader Forge v1.26 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.26;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:0,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:4480,x:32719,y:32712,varname:node_4480,prsc:2|custl-3201-RGB;n:type:ShaderForge.SFN_Tex2d,id:3201,x:32536,y:32953,ptovrint:False,ptlb:MainTex,ptin:_MainTex,varname:node_3201,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-6609-OUT;n:type:ShaderForge.SFN_TexCoord,id:3398,x:32017,y:32953,varname:node_3398,prsc:2,uv:0;n:type:ShaderForge.SFN_Multiply,id:9421,x:32198,y:32953,varname:node_9421,prsc:2|A-3398-UVOUT,B-4701-OUT;n:type:ShaderForge.SFN_Multiply,id:8818,x:32017,y:33172,varname:node_8818,prsc:2|A-9229-OUT,B-4701-OUT;n:type:ShaderForge.SFN_Vector1,id:9229,x:32017,y:33091,varname:node_9229,prsc:2,v1:0.5;n:type:ShaderForge.SFN_Subtract,id:646,x:32198,y:33091,varname:node_646,prsc:2|A-9229-OUT,B-8818-OUT;n:type:ShaderForge.SFN_Add,id:6609,x:32368,y:32953,varname:node_6609,prsc:2|A-9421-OUT,B-646-OUT;n:type:ShaderForge.SFN_Slider,id:4701,x:31635,y:33082,ptovrint:False,ptlb:Scale,ptin:_Scale,varname:node_4701,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:1,max:8;proporder:3201-4701;pass:END;sub:END;*/

Shader "Oboro/UVScale" {
    Properties {
        _MainTex ("MainTex", 2D) = "white" {}
        _Scale ("Scale", Range(0.001, 8)) = 1
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
                float node_9229 = 0.5;
                float2 node_6609 = ((i.uv0/_Scale)-((node_9229/_Scale) - node_9229));
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
