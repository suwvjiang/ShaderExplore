// Shader created with Shader Forge v1.26 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.26;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:0,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:8718,x:33177,y:32671,varname:node_8718,prsc:2|custl-7831-OUT;n:type:ShaderForge.SFN_LightVector,id:6537,x:32071,y:32864,varname:node_6537,prsc:2;n:type:ShaderForge.SFN_NormalVector,id:119,x:32071,y:33003,prsc:2,pt:False;n:type:ShaderForge.SFN_Dot,id:9068,x:32253,y:32928,varname:node_9068,prsc:2,dt:0|A-6537-OUT,B-119-OUT;n:type:ShaderForge.SFN_Clamp01,id:1586,x:32439,y:32928,varname:node_1586,prsc:2|IN-9068-OUT;n:type:ShaderForge.SFN_Cubemap,id:8830,x:32439,y:33099,ptovrint:False,ptlb:Cubemap,ptin:_Cubemap,varname:node_8830,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,cube:382e58f99a53e7b4e905af7b6632bb0f,pvfc:0;n:type:ShaderForge.SFN_Add,id:8919,x:32787,y:32926,varname:node_8919,prsc:2|A-1586-OUT,B-9408-OUT;n:type:ShaderForge.SFN_Multiply,id:9408,x:32625,y:33099,varname:node_9408,prsc:2|A-8830-RGB,B-1220-RGB;n:type:ShaderForge.SFN_Color,id:1220,x:32439,y:33267,ptovrint:False,ptlb:ReflectionColor,ptin:_ReflectionColor,varname:node_1220,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_LightColor,id:5704,x:32777,y:32786,varname:node_5704,prsc:2;n:type:ShaderForge.SFN_Multiply,id:7831,x:32995,y:32910,varname:node_7831,prsc:2|A-5704-RGB,B-8919-OUT;proporder:8830-1220;pass:END;sub:END;*/

Shader "Oboro/DiffuseAmbientLightTest2" {
    Properties {
        _Cubemap ("Cubemap", Cube) = "_Skybox" {}
        _ReflectionColor ("ReflectionColor", Color) = (0.5,0.5,0.5,1)
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
            uniform float4 _LightColor0;
            uniform samplerCUBE _Cubemap;
            uniform float4 _ReflectionColor;
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
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
                float3 viewReflectDirection = reflect( -viewDirection, normalDirection );
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 lightColor = _LightColor0.rgb;
////// Lighting:
                float3 finalColor = (_LightColor0.rgb*(saturate(dot(lightDirection,i.normalDir))+(texCUBE(_Cubemap,viewReflectDirection).rgb*_ReflectionColor.rgb)));
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
