// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Shader created with Shader Forge v1.26 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.26;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:1,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:3184,x:32583,y:32930,varname:node_3184,prsc:2|diff-2323-OUT;n:type:ShaderForge.SFN_Tex2d,id:4843,x:31830,y:32792,ptovrint:False,ptlb:MainTex,ptin:_MainTex,varname:_MainTex,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Tex2d,id:4347,x:31818,y:33156,ptovrint:False,ptlb:SnowAlphaTex,ptin:_SnowAlphaTex,varname:_SnowAlphaTex,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:28c7aad1372ff114b90d330f8a2dd938,ntxv:0,isnm:False|UVIN-34-OUT;n:type:ShaderForge.SFN_Tex2d,id:9503,x:31818,y:32975,ptovrint:False,ptlb:SnowMap,ptin:_SnowMap,varname:_SnowMap,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-34-OUT;n:type:ShaderForge.SFN_Lerp,id:2323,x:32160,y:32929,varname:node_2323,prsc:2|A-4843-RGB,B-9503-RGB,T-1524-OUT;n:type:ShaderForge.SFN_Slider,id:630,x:31661,y:33456,ptovrint:False,ptlb:SnowGenerate,ptin:_SnowGenerate,varname:_SnowGenerate,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:1,max:10;n:type:ShaderForge.SFN_FragmentPosition,id:8443,x:31461,y:33128,varname:node_8443,prsc:2;n:type:ShaderForge.SFN_Append,id:34,x:31631,y:33156,varname:node_34,prsc:2|A-8443-X,B-8443-Z;n:type:ShaderForge.SFN_Vector3,id:2612,x:31488,y:33541,varname:node_2612,prsc:2,v1:0,v2:1,v3:0;n:type:ShaderForge.SFN_NormalVector,id:6327,x:31488,y:33635,prsc:2,pt:False;n:type:ShaderForge.SFN_Dot,id:7855,x:31656,y:33541,varname:node_7855,prsc:2,dt:0|A-2612-OUT,B-6327-OUT;n:type:ShaderForge.SFN_Power,id:6740,x:32160,y:33173,varname:node_6740,prsc:2|VAL-4415-OUT,EXP-8938-OUT;n:type:ShaderForge.SFN_Multiply,id:1524,x:32338,y:33272,varname:node_1524,prsc:2|A-6740-OUT,B-5157-OUT;n:type:ShaderForge.SFN_Clamp01,id:5157,x:32160,y:33379,varname:node_5157,prsc:2|IN-9416-OUT;n:type:ShaderForge.SFN_Power,id:9416,x:31999,y:33541,varname:node_9416,prsc:2|VAL-5554-OUT,EXP-2865-OUT;n:type:ShaderForge.SFN_Vector1,id:9685,x:31818,y:33316,varname:node_9685,prsc:2,v1:-0.2;n:type:ShaderForge.SFN_Vector1,id:2865,x:31828,y:33691,varname:node_2865,prsc:2,v1:4;n:type:ShaderForge.SFN_Add,id:5554,x:31828,y:33541,varname:node_5554,prsc:2|A-7855-OUT,B-2445-OUT;n:type:ShaderForge.SFN_Vector1,id:2445,x:31656,y:33691,varname:node_2445,prsc:2,v1:0.1;n:type:ShaderForge.SFN_Add,id:4415,x:31999,y:33173,varname:node_4415,prsc:2|A-4347-R,B-9685-OUT;n:type:ShaderForge.SFN_Vector1,id:7683,x:31818,y:33379,varname:node_7683,prsc:2,v1:10;n:type:ShaderForge.SFN_Subtract,id:8938,x:31999,y:33379,varname:node_8938,prsc:2|A-7683-OUT,B-630-OUT;proporder:4843-9503-4347-630;pass:END;sub:END;*/

Shader "Oboro/GenerateSnow" {
    Properties {
        _MainTex ("MainTex", 2D) = "white" {}
        _SnowMap ("SnowMap", 2D) = "white" {}
        _SnowAlphaTex ("SnowAlphaTex", 2D) = "white" {}
        _SnowGenerate ("SnowGenerate", Range(0, 10)) = 1
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
            uniform float4 _LightColor0;
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform sampler2D _SnowAlphaTex; uniform float4 _SnowAlphaTex_ST;
            uniform sampler2D _SnowMap; uniform float4 _SnowMap_ST;
            uniform float _SnowGenerate;
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
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos(v.vertex );
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
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
/////// Diffuse:
                float NdotL = max(0.0,dot( normalDirection, lightDirection ));
                float3 directDiffuse = max( 0.0, NdotL) * attenColor;
                float3 indirectDiffuse = float3(0,0,0);
                indirectDiffuse += UNITY_LIGHTMODEL_AMBIENT.rgb; // Ambient Light
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(i.uv0, _MainTex));
                float2 node_34 = float2(i.posWorld.r,i.posWorld.b);
                float4 _SnowMap_var = tex2D(_SnowMap,TRANSFORM_TEX(node_34, _SnowMap));
                float4 _SnowAlphaTex_var = tex2D(_SnowAlphaTex,TRANSFORM_TEX(node_34, _SnowAlphaTex));
                float3 diffuseColor = lerp(_MainTex_var.rgb,_SnowMap_var.rgb,(pow((_SnowAlphaTex_var.r+(-0.2)),(10.0-_SnowGenerate))*saturate(pow((dot(float3(0,1,0),i.normalDir)+0.1),4.0))));
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
            Name "FORWARD_DELTA"
            Tags {
                "LightMode"="ForwardAdd"
            }
            Blend One One
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDADD
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdadd_fullshadows
            #pragma multi_compile_fog
            #pragma exclude_renderers gles3 metal d3d11_9x xbox360 xboxone ps3 ps4 psp2 
            #pragma target 3.0
            uniform float4 _LightColor0;
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform sampler2D _SnowAlphaTex; uniform float4 _SnowAlphaTex_ST;
            uniform sampler2D _SnowMap; uniform float4 _SnowMap_ST;
            uniform float _SnowGenerate;
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
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos(v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3 normalDirection = i.normalDir;
                float3 lightDirection = normalize(lerp(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - i.posWorld.xyz,_WorldSpaceLightPos0.w));
                float3 lightColor = _LightColor0.rgb;
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
/////// Diffuse:
                float NdotL = max(0.0,dot( normalDirection, lightDirection ));
                float3 directDiffuse = max( 0.0, NdotL) * attenColor;
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(i.uv0, _MainTex));
                float2 node_34 = float2(i.posWorld.r,i.posWorld.b);
                float4 _SnowMap_var = tex2D(_SnowMap,TRANSFORM_TEX(node_34, _SnowMap));
                float4 _SnowAlphaTex_var = tex2D(_SnowAlphaTex,TRANSFORM_TEX(node_34, _SnowAlphaTex));
                float3 diffuseColor = lerp(_MainTex_var.rgb,_SnowMap_var.rgb,(pow((_SnowAlphaTex_var.r+(-0.2)),(10.0-_SnowGenerate))*saturate(pow((dot(float3(0,1,0),i.normalDir)+0.1),4.0))));
                float3 diffuse = directDiffuse * diffuseColor;
/// Final Color:
                float3 finalColor = diffuse;
                fixed4 finalRGBA = fixed4(finalColor * 1,0);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
