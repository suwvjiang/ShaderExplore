// Shader created with Shader Forge v1.26 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.26;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:0,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:4457,x:32756,y:33009,varname:node_4457,prsc:2|diff-4880-OUT,custl-7720-RGB,voffset-7312-OUT;n:type:ShaderForge.SFN_Tex2d,id:7720,x:32374,y:33058,ptovrint:False,ptlb:MainTex,ptin:_MainTex,varname:_MainTex,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-8304-UVOUT;n:type:ShaderForge.SFN_TexCoord,id:8304,x:31663,y:33245,varname:node_8304,prsc:2,uv:0;n:type:ShaderForge.SFN_Time,id:1543,x:31865,y:33511,varname:node_1543,prsc:2;n:type:ShaderForge.SFN_Add,id:1793,x:32202,y:33266,varname:node_1793,prsc:2|A-9477-OUT,B-9187-OUT;n:type:ShaderForge.SFN_Multiply,id:9477,x:32034,y:33266,varname:node_9477,prsc:2|A-5833-OUT,B-8140-OUT;n:type:ShaderForge.SFN_ValueProperty,id:8140,x:31865,y:33410,ptovrint:False,ptlb:wavelength,ptin:_wavelength,varname:_wavelength,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Multiply,id:9187,x:32035,y:33570,varname:node_9187,prsc:2|A-1543-TTR,B-3504-OUT;n:type:ShaderForge.SFN_ValueProperty,id:3504,x:31865,y:33708,ptovrint:False,ptlb:Frequency,ptin:_Frequency,varname:_Frequency,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Sin,id:2461,x:32374,y:33266,varname:node_2461,prsc:2|IN-1793-OUT;n:type:ShaderForge.SFN_Add,id:5833,x:31865,y:33266,varname:node_5833,prsc:2|A-8304-U,B-8304-V;n:type:ShaderForge.SFN_Multiply,id:7312,x:32575,y:33371,varname:node_7312,prsc:2|A-2461-OUT,B-7415-OUT,C-7080-OUT;n:type:ShaderForge.SFN_Vector3,id:7415,x:32369,y:33389,varname:node_7415,prsc:2,v1:0.25,v2:1,v3:0.5;n:type:ShaderForge.SFN_ValueProperty,id:7080,x:32369,y:33524,ptovrint:False,ptlb:Intensity,ptin:_Intensity,varname:_Intensity,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Add,id:9836,x:31865,y:33821,varname:node_9836,prsc:2|A-8304-U,B-3138-OUT;n:type:ShaderForge.SFN_Vector1,id:3138,x:31626,y:33834,varname:node_3138,prsc:2,v1:0.1;n:type:ShaderForge.SFN_Vector3,id:4880,x:32380,y:32929,varname:node_4880,prsc:2,v1:0.6965518,v2:1,v3:0;proporder:7720-7080-3504-8140;pass:END;sub:END;*/

Shader "Oboro/WaveFlag" {
    Properties {
        _MainTex ("MainTex", 2D) = "white" {}
        _Intensity ("Intensity", Float ) = 1
        _Frequency ("Frequency", Float ) = 1
        _wavelength ("wavelength", Float ) = 1
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
            Cull Off
            
            
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
            uniform float4 _TimeEditor;
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform float _wavelength;
            uniform float _Frequency;
            uniform float _Intensity;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                LIGHTING_COORDS(3,4)
                UNITY_FOG_COORDS(5)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                float4 node_1543 = _Time + _TimeEditor;
                v.vertex.xyz += (sin((((o.uv0.r+o.uv0.g)*_wavelength)+(node_1543.a*_Frequency)))*float3(0.25,1,0.5)*_Intensity);
                o.posWorld = mul(_Object2World, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                i.normalDir = normalize(i.normalDir);
                i.normalDir *= faceSign;
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 lightColor = _LightColor0.rgb;
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
/////// Diffuse:
                float NdotL = max(0.0,dot( normalDirection, lightDirection ));
                float3 directDiffuse = max( 0.0, NdotL) * attenColor;
                float3 indirectDiffuse = float3(0,0,0);
                indirectDiffuse += UNITY_LIGHTMODEL_AMBIENT.rgb; // Ambient Light
                float3 diffuseColor = float3(0.6965518,1,0);
                float3 diffuse = (directDiffuse + indirectDiffuse) * diffuseColor;
/// Final Color:
                float3 finalColor = diffuse;
                fixed4 finalRGBA = fixed4(finalColor,1);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
        Pass {
            Name "ShadowCaster"
            Tags {
                "LightMode"="ShadowCaster"
            }
            Offset 1, 1
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_SHADOWCASTER
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            #pragma multi_compile_fog
            #pragma exclude_renderers gles3 metal d3d11_9x xbox360 xboxone ps3 ps4 psp2 
            #pragma target 3.0
            uniform float4 _TimeEditor;
            uniform float _wavelength;
            uniform float _Frequency;
            uniform float _Intensity;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                V2F_SHADOW_CASTER;
                float2 uv0 : TEXCOORD1;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                float4 node_1543 = _Time + _TimeEditor;
                v.vertex.xyz += (sin((((o.uv0.r+o.uv0.g)*_wavelength)+(node_1543.a*_Frequency)))*float3(0.25,1,0.5)*_Intensity);
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex );
                TRANSFER_SHADOW_CASTER(o)
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
