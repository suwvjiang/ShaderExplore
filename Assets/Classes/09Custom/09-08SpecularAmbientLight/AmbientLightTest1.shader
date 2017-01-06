// Shader created with Shader Forge v1.26 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.26;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:0,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:5759,x:32825,y:32705,varname:node_5759,prsc:2|custl-8034-OUT;n:type:ShaderForge.SFN_LightVector,id:5628,x:31776,y:33071,varname:node_5628,prsc:2;n:type:ShaderForge.SFN_Dot,id:4904,x:31945,y:32970,varname:node_4904,prsc:2,dt:0|A-144-OUT,B-5628-OUT;n:type:ShaderForge.SFN_Clamp01,id:3217,x:32112,y:32970,varname:node_3217,prsc:2|IN-4904-OUT;n:type:ShaderForge.SFN_Add,id:8034,x:32652,y:32945,varname:node_8034,prsc:2|A-3960-OUT,B-1093-OUT;n:type:ShaderForge.SFN_Cubemap,id:1998,x:31945,y:33142,ptovrint:False,ptlb:DiffuseAmbient,ptin:_DiffuseAmbient,varname:node_1998,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,cube:382e58f99a53e7b4e905af7b6632bb0f,pvfc:0;n:type:ShaderForge.SFN_Multiply,id:1093,x:32296,y:32970,varname:node_1093,prsc:2|A-3217-OUT,B-1998-RGB,C-4689-OUT;n:type:ShaderForge.SFN_Slider,id:4689,x:31788,y:33313,ptovrint:False,ptlb:DiffuseAmbientLight,ptin:_DiffuseAmbientLight,varname:node_4689,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.5,max:0.5;n:type:ShaderForge.SFN_NormalVector,id:144,x:31776,y:32925,prsc:2,pt:False;n:type:ShaderForge.SFN_Dot,id:2152,x:31945,y:32776,varname:node_2152,prsc:2,dt:0|A-4856-OUT,B-144-OUT;n:type:ShaderForge.SFN_Cubemap,id:852,x:31945,y:32626,ptovrint:False,ptlb:SpecularAmbient,ptin:_SpecularAmbient,varname:_DiffuseAmbient_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,cube:382e58f99a53e7b4e905af7b6632bb0f,pvfc:0;n:type:ShaderForge.SFN_Multiply,id:3960,x:32473,y:32739,varname:node_3960,prsc:2|A-65-OUT,B-1311-OUT;n:type:ShaderForge.SFN_Slider,id:65,x:31776,y:32509,ptovrint:False,ptlb:SpecularAmbientLight,ptin:_SpecularAmbientLight,varname:_DiffuseAmbientLight_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.5,max:0.5;n:type:ShaderForge.SFN_HalfVector,id:4856,x:31776,y:32797,varname:node_4856,prsc:2;n:type:ShaderForge.SFN_Power,id:9578,x:32125,y:32776,varname:node_9578,prsc:2|VAL-2152-OUT,EXP-87-OUT;n:type:ShaderForge.SFN_Vector1,id:87,x:31945,y:32915,varname:node_87,prsc:2,v1:60;n:type:ShaderForge.SFN_Add,id:1311,x:32296,y:32760,varname:node_1311,prsc:2|A-852-RGB,B-9578-OUT;proporder:1998-4689-852-65;pass:END;sub:END;*/

Shader "Oboro/AmbientLightTest1" {
    Properties {
        _DiffuseAmbient ("DiffuseAmbient", Cube) = "_Skybox" {}
        _DiffuseAmbientLight ("DiffuseAmbientLight", Range(0, 0.5)) = 0.5
        _SpecularAmbient ("SpecularAmbient", Cube) = "_Skybox" {}
        _SpecularAmbientLight ("SpecularAmbientLight", Range(0, 0.5)) = 0.5
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
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma multi_compile_fog
            #pragma exclude_renderers gles3 metal d3d11_9x xbox360 xboxone ps3 ps4 psp2 
            #pragma target 3.0
            uniform samplerCUBE _DiffuseAmbient;
            uniform float _DiffuseAmbientLight;
            uniform samplerCUBE _SpecularAmbient;
            uniform float _SpecularAmbientLight;
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
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
                float3 viewReflectDirection = reflect( -viewDirection, normalDirection );
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 halfDirection = normalize(viewDirection+lightDirection);
////// Lighting:
                float3 finalColor = ((_SpecularAmbientLight*(texCUBE(_SpecularAmbient,viewReflectDirection).rgb+pow(dot(halfDirection,i.normalDir),60.0)))+(saturate(dot(i.normalDir,lightDirection))*texCUBE(_DiffuseAmbient,viewReflectDirection).rgb*_DiffuseAmbientLight));
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
