// Shader created with Shader Forge v1.26 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.26;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:0,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:True,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:1864,x:33276,y:32535,varname:node_1864,prsc:2|custl-6866-OUT;n:type:ShaderForge.SFN_LightVector,id:4994,x:32064,y:32828,varname:node_4994,prsc:2;n:type:ShaderForge.SFN_NormalVector,id:4404,x:32064,y:32972,prsc:2,pt:False;n:type:ShaderForge.SFN_Dot,id:5268,x:32234,y:32905,varname:node_5268,prsc:2,dt:0|A-4994-OUT,B-4404-OUT;n:type:ShaderForge.SFN_Clamp01,id:6727,x:32583,y:32905,varname:node_6727,prsc:2|IN-1417-OUT;n:type:ShaderForge.SFN_Negate,id:1417,x:32411,y:32905,varname:node_1417,prsc:2|IN-5268-OUT;n:type:ShaderForge.SFN_Multiply,id:4032,x:32753,y:32905,varname:node_4032,prsc:2|A-6727-OUT,B-3558-OUT;n:type:ShaderForge.SFN_Slider,id:3558,x:32411,y:33079,ptovrint:False,ptlb:node_3558,ptin:_node_3558,varname:node_3558,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Add,id:2377,x:32922,y:32775,varname:node_2377,prsc:2|A-7348-OUT,B-4032-OUT;n:type:ShaderForge.SFN_Clamp01,id:7348,x:32411,y:32772,varname:node_7348,prsc:2|IN-5268-OUT;n:type:ShaderForge.SFN_Multiply,id:6866,x:33099,y:32775,varname:node_6866,prsc:2|A-2377-OUT,B-1401-RGB;n:type:ShaderForge.SFN_LightColor,id:1401,x:32922,y:32916,varname:node_1401,prsc:2;proporder:3558;pass:END;sub:END;*/

Shader "Oboro/TransmissionTest1" {
    Properties {
        _node_3558 ("node_3558", Range(0, 1)) = 0
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
            
            
            Stencil {
                Ref 128
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
            uniform float4 _LightColor0;
            uniform float _node_3558;
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
                float3 lightColor = _LightColor0.rgb;
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3 normalDirection = i.normalDir;
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 lightColor = _LightColor0.rgb;
////// Lighting:
                float node_5268 = dot(lightDirection,i.normalDir);
                float3 finalColor = ((saturate(node_5268)+(saturate((-1*node_5268))*_node_3558))*_LightColor0.rgb);
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
