// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Shader created with Shader Forge v1.26 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.26;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:1,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:6523,x:32676,y:33030,varname:node_6523,prsc:2|diff-8534-OUT;n:type:ShaderForge.SFN_ChannelBlend,id:8534,x:32484,y:33030,varname:node_8534,prsc:2,chbt:1|M-1014-RGB,R-3709-RGB,G-6605-RGB,B-1069-RGB,BTM-7507-RGB;n:type:ShaderForge.SFN_Tex2d,id:1014,x:32181,y:32587,ptovrint:False,ptlb:Mask,ptin:_Mask,varname:_Mask,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:a1edc6c400f4414408434a7a36d24854,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Tex2d,id:3709,x:32181,y:32813,ptovrint:False,ptlb:MainTex01,ptin:_MainTex01,varname:_MainTex01,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:231cc28d8a340ee43a09a70ed505d70c,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Tex2d,id:6605,x:32181,y:33041,ptovrint:False,ptlb:MainTex02,ptin:_MainTex02,varname:_MainTex02,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:018e926b9c6d03348b7b3e9e20d464a0,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Tex2d,id:1069,x:32188,y:33261,ptovrint:False,ptlb:MainTex03,ptin:_MainTex03,varname:_MainTex03,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:3361ab952dc4cd846a96a29ab7ad20c0,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Tex2d,id:7507,x:32188,y:33504,ptovrint:False,ptlb:MainTex04,ptin:_MainTex04,varname:_MainTex04,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:c91ec3df3966e7c4abef1f6f644fe16d,ntxv:0,isnm:False;proporder:3709-6605-1069-7507-1014;pass:END;sub:END;*/

Shader "Oboro/ChannelBlend" {
    Properties {
        _MainTex01 ("MainTex01", 2D) = "white" {}
        _MainTex02 ("MainTex02", 2D) = "white" {}
        _MainTex03 ("MainTex03", 2D) = "white" {}
        _MainTex04 ("MainTex04", 2D) = "white" {}
        _Mask ("Mask", 2D) = "white" {}
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
            uniform sampler2D _Mask; uniform float4 _Mask_ST;
            uniform sampler2D _MainTex01; uniform float4 _MainTex01_ST;
            uniform sampler2D _MainTex02; uniform float4 _MainTex02_ST;
            uniform sampler2D _MainTex03; uniform float4 _MainTex03_ST;
            uniform sampler2D _MainTex04; uniform float4 _MainTex04_ST;
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
                float4 _Mask_var = tex2D(_Mask,TRANSFORM_TEX(i.uv0, _Mask));
                float4 _MainTex04_var = tex2D(_MainTex04,TRANSFORM_TEX(i.uv0, _MainTex04));
                float4 _MainTex01_var = tex2D(_MainTex01,TRANSFORM_TEX(i.uv0, _MainTex01));
                float4 _MainTex02_var = tex2D(_MainTex02,TRANSFORM_TEX(i.uv0, _MainTex02));
                float4 _MainTex03_var = tex2D(_MainTex03,TRANSFORM_TEX(i.uv0, _MainTex03));
                float3 diffuseColor = (lerp( lerp( lerp( _MainTex04_var.rgb, _MainTex01_var.rgb, _Mask_var.rgb.r ), _MainTex02_var.rgb, _Mask_var.rgb.g ), _MainTex03_var.rgb, _Mask_var.rgb.b ));
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
            uniform sampler2D _Mask; uniform float4 _Mask_ST;
            uniform sampler2D _MainTex01; uniform float4 _MainTex01_ST;
            uniform sampler2D _MainTex02; uniform float4 _MainTex02_ST;
            uniform sampler2D _MainTex03; uniform float4 _MainTex03_ST;
            uniform sampler2D _MainTex04; uniform float4 _MainTex04_ST;
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
                float4 _Mask_var = tex2D(_Mask,TRANSFORM_TEX(i.uv0, _Mask));
                float4 _MainTex04_var = tex2D(_MainTex04,TRANSFORM_TEX(i.uv0, _MainTex04));
                float4 _MainTex01_var = tex2D(_MainTex01,TRANSFORM_TEX(i.uv0, _MainTex01));
                float4 _MainTex02_var = tex2D(_MainTex02,TRANSFORM_TEX(i.uv0, _MainTex02));
                float4 _MainTex03_var = tex2D(_MainTex03,TRANSFORM_TEX(i.uv0, _MainTex03));
                float3 diffuseColor = (lerp( lerp( lerp( _MainTex04_var.rgb, _MainTex01_var.rgb, _Mask_var.rgb.r ), _MainTex02_var.rgb, _Mask_var.rgb.g ), _MainTex03_var.rgb, _Mask_var.rgb.b ));
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
