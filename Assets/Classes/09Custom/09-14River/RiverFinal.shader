// Shader created with Shader Forge v1.26 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.26;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:1,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:3,bdst:7,dpts:2,wrdp:False,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:False,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0,fgcg:0.616,fgcb:1,fgca:1,fgde:0.01,fgrn:10,fgrf:100,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:3892,x:32854,y:32742,varname:node_3892,prsc:2|diff-9229-OUT,amdfl-8699-OUT,alpha-7071-OUT,refract-2306-OUT;n:type:ShaderForge.SFN_Tex2d,id:3108,x:32481,y:32734,ptovrint:False,ptlb:MainTex,ptin:_MainTex,varname:node_6827,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:3a9827e5c0fbc6e47826a509282e99a4,ntxv:0,isnm:False|UVIN-162-OUT;n:type:ShaderForge.SFN_Tex2d,id:8398,x:31953,y:32757,ptovrint:False,ptlb:FlowMap,ptin:_FlowMap,varname:node_3912,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:c1b38a07a3a28ac49bfb34dcfeae2381,ntxv:0,isnm:False|UVIN-1600-OUT;n:type:ShaderForge.SFN_Multiply,id:9715,x:32134,y:32774,varname:node_9715,prsc:2|A-8398-R,B-8230-OUT;n:type:ShaderForge.SFN_ValueProperty,id:8230,x:31953,y:32942,ptovrint:False,ptlb:FlowIntensity,ptin:_FlowIntensity,varname:node_3864,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0.01;n:type:ShaderForge.SFN_Add,id:162,x:32299,y:32734,varname:node_162,prsc:2|A-1850-OUT,B-6083-UVOUT,C-9715-OUT;n:type:ShaderForge.SFN_TexCoord,id:6083,x:31462,y:32627,varname:node_6083,prsc:2,uv:0;n:type:ShaderForge.SFN_Time,id:9604,x:31284,y:32791,varname:node_9604,prsc:2;n:type:ShaderForge.SFN_Multiply,id:8338,x:31462,y:32775,varname:node_8338,prsc:2|A-9199-OUT,B-9604-T;n:type:ShaderForge.SFN_Multiply,id:6428,x:31462,y:32914,varname:node_6428,prsc:2|A-9604-T,B-793-OUT;n:type:ShaderForge.SFN_ValueProperty,id:9199,x:31284,y:32727,ptovrint:False,ptlb:USpeed,ptin:_USpeed,varname:node_3093,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_ValueProperty,id:793,x:31284,y:32934,ptovrint:False,ptlb:VSpeed,ptin:_VSpeed,varname:node_5269,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Append,id:4324,x:31630,y:32775,varname:node_4324,prsc:2|A-8338-OUT,B-6428-OUT;n:type:ShaderForge.SFN_Add,id:1600,x:31792,y:32757,varname:node_1600,prsc:2|A-6083-UVOUT,B-4324-OUT;n:type:ShaderForge.SFN_Multiply,id:1850,x:31792,y:32541,varname:node_1850,prsc:2|A-7587-OUT,B-4324-OUT;n:type:ShaderForge.SFN_ValueProperty,id:7587,x:31462,y:32539,ptovrint:False,ptlb:TexSpeed,ptin:_TexSpeed,varname:node_9011,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:-0.5;n:type:ShaderForge.SFN_Multiply,id:7071,x:32659,y:33083,varname:node_7071,prsc:2|A-4929-OUT,B-3172-OUT;n:type:ShaderForge.SFN_Slider,id:4929,x:32332,y:33083,ptovrint:False,ptlb:Alpha,ptin:_Alpha,varname:node_4690,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.5,max:1;n:type:ShaderForge.SFN_Multiply,id:2306,x:32659,y:33211,varname:node_2306,prsc:2|A-3172-OUT,B-9715-OUT;n:type:ShaderForge.SFN_Cubemap,id:7944,x:32481,y:32914,ptovrint:False,ptlb:Cubemap,ptin:_Cubemap,varname:node_7944,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,pvfc:0;n:type:ShaderForge.SFN_Multiply,id:8699,x:32659,y:32893,varname:node_8699,prsc:2|A-5259-OUT,B-7944-RGB,C-8398-R;n:type:ShaderForge.SFN_Fresnel,id:5259,x:32332,y:32892,varname:node_5259,prsc:2;n:type:ShaderForge.SFN_Slider,id:5874,x:31821,y:32454,ptovrint:False,ptlb:specular,ptin:_specular,varname:node_5874,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Add,id:9229,x:32659,y:32713,varname:node_9229,prsc:2|A-4069-OUT,B-3108-RGB;n:type:ShaderForge.SFN_Multiply,id:4069,x:32299,y:32601,varname:node_4069,prsc:2|A-5874-OUT,B-8398-R;n:type:ShaderForge.SFN_DepthBlend,id:3172,x:32489,y:33211,varname:node_3172,prsc:2|DIST-4961-OUT;n:type:ShaderForge.SFN_Slider,id:4961,x:32171,y:33211,ptovrint:False,ptlb:Distance,ptin:_Distance,varname:node_4961,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:20;proporder:3108-8398-7944-4929-8230-9199-793-7587-5874-4961;pass:END;sub:END;*/

Shader "Oboro/RiverFinal" {
    Properties {
        _MainTex ("MainTex", 2D) = "white" {}
        _FlowMap ("FlowMap", 2D) = "white" {}
        _Cubemap ("Cubemap", Cube) = "_Skybox" {}
        _Alpha ("Alpha", Range(0, 1)) = 0.5
        _FlowIntensity ("FlowIntensity", Float ) = 0.01
        _USpeed ("USpeed", Float ) = 1
        _VSpeed ("VSpeed", Float ) = 0
        _TexSpeed ("TexSpeed", Float ) = -0.5
        _specular ("specular", Range(0, 1)) = 0
        _Distance ("Distance", Range(0, 20)) = 0
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        LOD 100
        GrabPass{ }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma exclude_renderers gles3 metal d3d11_9x xbox360 xboxone ps3 ps4 psp2 
            #pragma target 3.0
            uniform float4 _LightColor0;
            uniform sampler2D _GrabTexture;
            uniform sampler2D _CameraDepthTexture;
            uniform float4 _TimeEditor;
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform sampler2D _FlowMap; uniform float4 _FlowMap_ST;
            uniform float _FlowIntensity;
            uniform float _USpeed;
            uniform float _VSpeed;
            uniform float _TexSpeed;
            uniform float _Alpha;
            uniform samplerCUBE _Cubemap;
            uniform float _specular;
            uniform float _Distance;
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
                float4 screenPos : TEXCOORD3;
                float4 projPos : TEXCOORD4;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.posWorld = mul(_Object2World, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex );
                o.projPos = ComputeScreenPos (o.pos);
                COMPUTE_EYEDEPTH(o.projPos.z);
                o.screenPos = o.pos;
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                #if UNITY_UV_STARTS_AT_TOP
                    float grabSign = -_ProjectionParams.x;
                #else
                    float grabSign = _ProjectionParams.x;
                #endif
                i.normalDir = normalize(i.normalDir);
                i.screenPos = float4( i.screenPos.xy / i.screenPos.w, 0, 0 );
                i.screenPos.y *= _ProjectionParams.x;
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
                float3 viewReflectDirection = reflect( -viewDirection, normalDirection );
                float sceneZ = max(0,LinearEyeDepth (UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)))) - _ProjectionParams.g);
                float partZ = max(0,i.projPos.z - _ProjectionParams.g);
                float node_3172 = saturate((sceneZ-partZ)/_Distance);
                float4 node_9604 = _Time + _TimeEditor;
                float2 node_4324 = float2((_USpeed*node_9604.g),(node_9604.g*_VSpeed));
                float2 node_1600 = (i.uv0+node_4324);
                float4 _FlowMap_var = tex2D(_FlowMap,TRANSFORM_TEX(node_1600, _FlowMap));
                float node_9715 = (_FlowMap_var.r*_FlowIntensity);
                float node_2306 = (node_3172*node_9715);
                float2 sceneUVs = float2(1,grabSign)*i.screenPos.xy*0.5+0.5 + float2(node_2306,node_2306);
                float4 sceneColor = tex2D(_GrabTexture, sceneUVs);
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 lightColor = _LightColor0.rgb;
////// Lighting:
                float attenuation = 1;
                float3 attenColor = attenuation * _LightColor0.xyz;
/////// Diffuse:
                float NdotL = max(0.0,dot( normalDirection, lightDirection ));
                float3 directDiffuse = max( 0.0, NdotL) * attenColor;
                float3 indirectDiffuse = float3(0,0,0);
                indirectDiffuse += UNITY_LIGHTMODEL_AMBIENT.rgb; // Ambient Light
                indirectDiffuse += ((1.0-max(0,dot(normalDirection, viewDirection)))*texCUBE(_Cubemap,viewReflectDirection).rgb*_FlowMap_var.r); // Diffuse Ambient Light
                float2 node_162 = ((_TexSpeed*node_4324)+i.uv0+node_9715);
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(node_162, _MainTex));
                float3 diffuseColor = ((_specular*_FlowMap_var.r)+_MainTex_var.rgb);
                float3 diffuse = (directDiffuse + indirectDiffuse) * diffuseColor;
/// Final Color:
                float3 finalColor = diffuse;
                return fixed4(lerp(sceneColor.rgb, finalColor,(_Alpha*node_3172)),1);
            }
            ENDCG
        }
        Pass {
            Name "FORWARD_DELTA"
            Tags {
                "LightMode"="ForwardAdd"
            }
            Blend One One
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDADD
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdadd
            #pragma exclude_renderers gles3 metal d3d11_9x xbox360 xboxone ps3 ps4 psp2 
            #pragma target 3.0
            uniform float4 _LightColor0;
            uniform sampler2D _GrabTexture;
            uniform sampler2D _CameraDepthTexture;
            uniform float4 _TimeEditor;
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform sampler2D _FlowMap; uniform float4 _FlowMap_ST;
            uniform float _FlowIntensity;
            uniform float _USpeed;
            uniform float _VSpeed;
            uniform float _TexSpeed;
            uniform float _Alpha;
            uniform float _specular;
            uniform float _Distance;
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
                float4 screenPos : TEXCOORD3;
                float4 projPos : TEXCOORD4;
                LIGHTING_COORDS(5,6)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.posWorld = mul(_Object2World, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex );
                o.projPos = ComputeScreenPos (o.pos);
                COMPUTE_EYEDEPTH(o.projPos.z);
                o.screenPos = o.pos;
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                #if UNITY_UV_STARTS_AT_TOP
                    float grabSign = -_ProjectionParams.x;
                #else
                    float grabSign = _ProjectionParams.x;
                #endif
                i.normalDir = normalize(i.normalDir);
                i.screenPos = float4( i.screenPos.xy / i.screenPos.w, 0, 0 );
                i.screenPos.y *= _ProjectionParams.x;
                float3 normalDirection = i.normalDir;
                float sceneZ = max(0,LinearEyeDepth (UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)))) - _ProjectionParams.g);
                float partZ = max(0,i.projPos.z - _ProjectionParams.g);
                float node_3172 = saturate((sceneZ-partZ)/_Distance);
                float4 node_9604 = _Time + _TimeEditor;
                float2 node_4324 = float2((_USpeed*node_9604.g),(node_9604.g*_VSpeed));
                float2 node_1600 = (i.uv0+node_4324);
                float4 _FlowMap_var = tex2D(_FlowMap,TRANSFORM_TEX(node_1600, _FlowMap));
                float node_9715 = (_FlowMap_var.r*_FlowIntensity);
                float node_2306 = (node_3172*node_9715);
                float2 sceneUVs = float2(1,grabSign)*i.screenPos.xy*0.5+0.5 + float2(node_2306,node_2306);
                float4 sceneColor = tex2D(_GrabTexture, sceneUVs);
                float3 lightDirection = normalize(lerp(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - i.posWorld.xyz,_WorldSpaceLightPos0.w));
                float3 lightColor = _LightColor0.rgb;
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
/////// Diffuse:
                float NdotL = max(0.0,dot( normalDirection, lightDirection ));
                float3 directDiffuse = max( 0.0, NdotL) * attenColor;
                float2 node_162 = ((_TexSpeed*node_4324)+i.uv0+node_9715);
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(node_162, _MainTex));
                float3 diffuseColor = ((_specular*_FlowMap_var.r)+_MainTex_var.rgb);
                float3 diffuse = directDiffuse * diffuseColor;
/// Final Color:
                float3 finalColor = diffuse;
                return fixed4(finalColor * (_Alpha*node_3172),0);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
