// Shader created with Shader Forge v1.26 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.26;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:0,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:7166,x:33124,y:32719,varname:node_7166,prsc:2|custl-9876-OUT;n:type:ShaderForge.SFN_LightVector,id:8158,x:32361,y:32900,varname:node_8158,prsc:2;n:type:ShaderForge.SFN_NormalVector,id:7033,x:32361,y:33034,prsc:2,pt:False;n:type:ShaderForge.SFN_Dot,id:2158,x:32537,y:32961,varname:node_2158,prsc:2,dt:0|A-8158-OUT,B-7033-OUT;n:type:ShaderForge.SFN_RemapRangeAdvanced,id:9876,x:32937,y:32960,varname:node_9876,prsc:2|IN-2158-OUT,IMIN-5356-OUT,IMAX-9842-OUT,OMIN-6296-OUT,OMAX-4746-OUT;n:type:ShaderForge.SFN_Vector1,id:5356,x:32712,y:33005,varname:node_5356,prsc:2,v1:-1;n:type:ShaderForge.SFN_Vector1,id:9842,x:32712,y:33071,varname:node_9842,prsc:2,v1:1;n:type:ShaderForge.SFN_Vector1,id:4746,x:32712,y:33208,varname:node_4746,prsc:2,v1:1;n:type:ShaderForge.SFN_Slider,id:4606,x:32555,y:33142,ptovrint:False,ptlb:oMin,ptin:_oMin,varname:node_4606,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:2;n:type:ShaderForge.SFN_Add,id:6296,x:32915,y:33141,varname:node_6296,prsc:2|A-4606-OUT,B-1987-OUT;n:type:ShaderForge.SFN_Vector1,id:1987,x:32712,y:33273,varname:node_1987,prsc:2,v1:-1;proporder:4606;pass:END;sub:END;*/

Shader "Oboro/LightWrappingTest2" {
    Properties {
        _oMin ("oMin", Range(0, 2)) = 0
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
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma multi_compile_fog
            #pragma exclude_renderers gles3 metal d3d11_9x xbox360 xboxone ps3 ps4 psp2 
            #pragma target 3.0
            uniform float _oMin;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float4 posWorld : TEXCOORD0;
                float3 normalDir : TEXCOORD1;
                LIGHTING_COORDS(2,3)
                UNITY_FOG_COORDS(4)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.posWorld = mul(_Object2World, v.vertex);
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3 normalDirection = i.normalDir;
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
////// Lighting:
                float node_5356 = (-1.0);
                float node_6296 = (_oMin+(-1.0));
                float node_9876 = (node_6296 + ( (dot(lightDirection,i.normalDir) - node_5356) * (1.0 - node_6296) ) / (1.0 - node_5356));
                float3 finalColor = float3(node_9876,node_9876,node_9876);
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
