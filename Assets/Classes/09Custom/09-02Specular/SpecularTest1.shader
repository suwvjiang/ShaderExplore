// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Shader created with Shader Forge v1.26 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.26;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:0,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:False,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:8080,x:32968,y:32722,varname:node_8080,prsc:2|custl-5571-OUT;n:type:ShaderForge.SFN_HalfVector,id:323,x:31892,y:32896,varname:node_323,prsc:2;n:type:ShaderForge.SFN_NormalVector,id:6210,x:31892,y:33051,prsc:2,pt:False;n:type:ShaderForge.SFN_Dot,id:351,x:32086,y:32982,varname:node_351,prsc:2,dt:0|A-323-OUT,B-6210-OUT;n:type:ShaderForge.SFN_Power,id:3041,x:32263,y:33081,varname:node_3041,prsc:2|VAL-351-OUT,EXP-1516-OUT;n:type:ShaderForge.SFN_Slider,id:1516,x:31892,y:33219,ptovrint:False,ptlb:Exp,ptin:_Exp,varname:node_1516,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:1,cur:10,max:30;n:type:ShaderForge.SFN_Add,id:3676,x:32602,y:32984,varname:node_3676,prsc:2|A-351-OUT,B-4362-OUT;n:type:ShaderForge.SFN_Multiply,id:5571,x:32785,y:32963,varname:node_5571,prsc:2|A-1100-RGB,B-3676-OUT;n:type:ShaderForge.SFN_LightColor,id:1100,x:32602,y:32846,varname:node_1100,prsc:2;n:type:ShaderForge.SFN_Multiply,id:4362,x:32443,y:33081,varname:node_4362,prsc:2|A-3041-OUT,B-5821-OUT;n:type:ShaderForge.SFN_Slider,id:5821,x:32106,y:33323,ptovrint:False,ptlb:Specular,ptin:_Specular,varname:node_5821,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:1,max:1;proporder:1516-5821;pass:END;sub:END;*/

Shader "Oboro/SpecularTest1" {
    Properties {
        _Exp ("Exp", Range(1, 30)) = 10
        _Specular ("Specular", Range(0, 1)) = 1
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
            uniform float _Exp;
            uniform float _Specular;
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
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos(v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 lightColor = _LightColor0.rgb;
                float3 halfDirection = normalize(viewDirection+lightDirection);
////// Lighting:
                float node_351 = dot(halfDirection,i.normalDir);
                float3 finalColor = (_LightColor0.rgb*(node_351+(pow(node_351,_Exp)*_Specular)));
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
