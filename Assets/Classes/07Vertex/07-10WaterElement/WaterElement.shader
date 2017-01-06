// Shader created with Shader Forge v1.26 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.26;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:0,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:3,bdst:7,dpts:2,wrdp:False,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:False,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:3772,x:33435,y:33419,varname:node_3772,prsc:2|custl-3515-OUT,alpha-8571-OUT,voffset-4132-OUT;n:type:ShaderForge.SFN_Tex2d,id:9759,x:33034,y:33330,ptovrint:False,ptlb:MainTex,ptin:_MainTex,varname:_MainTex,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:68d9373a2506d59449c0ab8d75086cbe,ntxv:0,isnm:False|UVIN-255-OUT;n:type:ShaderForge.SFN_Tex2d,id:4844,x:32548,y:33331,ptovrint:False,ptlb:FlowTex,ptin:_FlowTex,varname:_FlowTex,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:c1b38a07a3a28ac49bfb34dcfeae2381,ntxv:0,isnm:False|UVIN-5791-OUT;n:type:ShaderForge.SFN_Multiply,id:821,x:32719,y:33330,varname:node_821,prsc:2|A-9657-OUT,B-4844-R,C-2090-R;n:type:ShaderForge.SFN_ValueProperty,id:9657,x:32548,y:33252,ptovrint:False,ptlb:FlowIntensity,ptin:_FlowIntensity,varname:_FlowIntensity,prsc:0,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0.02;n:type:ShaderForge.SFN_Add,id:255,x:32875,y:33330,varname:node_255,prsc:0|A-821-OUT,B-5279-UVOUT;n:type:ShaderForge.SFN_Time,id:3929,x:32063,y:33309,varname:node_3929,prsc:2;n:type:ShaderForge.SFN_Add,id:5791,x:32390,y:33331,varname:node_5791,prsc:2|A-441-OUT,B-5279-UVOUT;n:type:ShaderForge.SFN_Multiply,id:441,x:32234,y:33331,varname:node_441,prsc:2|A-3929-T,B-2982-OUT;n:type:ShaderForge.SFN_ValueProperty,id:2982,x:32063,y:33463,ptovrint:False,ptlb:FlowSpeed,ptin:_FlowSpeed,varname:node_2982,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:-0.1;n:type:ShaderForge.SFN_TexCoord,id:5279,x:31987,y:33700,varname:node_5279,prsc:2,uv:0;n:type:ShaderForge.SFN_Tex2d,id:2090,x:32268,y:33686,ptovrint:False,ptlb:MaskTex,ptin:_MaskTex,varname:node_2090,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:3f892eb7bc351d34cbe3fd7fd301c470,ntxv:0,isnm:False|UVIN-5279-UVOUT;n:type:ShaderForge.SFN_Multiply,id:6266,x:32389,y:33957,varname:node_6266,prsc:2|A-5279-V,B-2644-OUT;n:type:ShaderForge.SFN_ValueProperty,id:2644,x:32219,y:33979,ptovrint:False,ptlb:WaveLength,ptin:_WaveLength,varname:_WaveLength,prsc:0,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:10;n:type:ShaderForge.SFN_Add,id:5913,x:32557,y:33957,varname:node_5913,prsc:2|A-6266-OUT,B-6864-OUT;n:type:ShaderForge.SFN_Time,id:4184,x:32219,y:34070,varname:node_4184,prsc:0;n:type:ShaderForge.SFN_Multiply,id:6864,x:32389,y:34091,varname:node_6864,prsc:2|A-4184-T,B-4676-OUT;n:type:ShaderForge.SFN_ValueProperty,id:4676,x:32219,y:34221,ptovrint:False,ptlb:Frequency,ptin:_Frequency,varname:_Frequency,prsc:0,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Sin,id:2408,x:32718,y:33957,varname:node_2408,prsc:0|IN-5913-OUT;n:type:ShaderForge.SFN_Multiply,id:4132,x:33053,y:33936,varname:node_4132,prsc:2|A-2090-R,B-9270-OUT,C-4709-OUT,D-5302-OUT;n:type:ShaderForge.SFN_ValueProperty,id:4709,x:32882,y:34096,ptovrint:False,ptlb:Amplitude,ptin:_Amplitude,varname:_Intensity,prsc:0,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0.03;n:type:ShaderForge.SFN_Add,id:9270,x:32882,y:33957,varname:node_9270,prsc:2|A-2408-OUT,B-1683-OUT;n:type:ShaderForge.SFN_Vector1,id:1683,x:32718,y:34096,varname:node_1683,prsc:2,v1:0.9;n:type:ShaderForge.SFN_FragmentPosition,id:7163,x:32567,y:33644,varname:node_7163,prsc:2;n:type:ShaderForge.SFN_Subtract,id:9023,x:32885,y:33682,varname:node_9023,prsc:2|A-7163-Y,B-7264-Y;n:type:ShaderForge.SFN_ObjectPosition,id:7264,x:32719,y:33715,varname:node_7264,prsc:2;n:type:ShaderForge.SFN_Add,id:8571,x:33053,y:33682,varname:node_8571,prsc:2|A-9023-OUT,B-8917-OUT;n:type:ShaderForge.SFN_Slider,id:8917,x:32713,y:33867,ptovrint:False,ptlb:AlphaOffset,ptin:_AlphaOffset,varname:node_8917,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:-1,cur:0,max:1;n:type:ShaderForge.SFN_Cubemap,id:5227,x:32719,y:33557,ptovrint:False,ptlb:CubeMap,ptin:_CubeMap,varname:node_5227,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,cube:382e58f99a53e7b4e905af7b6632bb0f,pvfc:0;n:type:ShaderForge.SFN_Multiply,id:3961,x:33034,y:33537,varname:node_3961,prsc:2|A-7145-OUT,B-5227-RGB,C-7795-OUT;n:type:ShaderForge.SFN_ValueProperty,id:7795,x:32875,y:33614,ptovrint:False,ptlb:RefrectionIntensity,ptin:_RefrectionIntensity,varname:node_7795,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0.5;n:type:ShaderForge.SFN_Add,id:3515,x:33205,y:33309,varname:node_3515,prsc:2|A-5042-RGB,B-9759-RGB,C-3961-OUT;n:type:ShaderForge.SFN_Fresnel,id:7145,x:32875,y:33453,varname:node_7145,prsc:2;n:type:ShaderForge.SFN_NormalVector,id:5302,x:32063,y:33074,prsc:2,pt:False;n:type:ShaderForge.SFN_Transform,id:5254,x:32391,y:33073,varname:node_5254,prsc:2,tffrom:0,tfto:3|IN-5302-OUT;n:type:ShaderForge.SFN_ComponentMask,id:2254,x:32548,y:33073,varname:node_2254,prsc:2,cc1:0,cc2:1,cc3:-1,cc4:-1|IN-5254-XYZ;n:type:ShaderForge.SFN_Multiply,id:4681,x:32703,y:33052,varname:node_4681,prsc:2|A-9684-OUT,B-2254-OUT;n:type:ShaderForge.SFN_Vector1,id:9684,x:32548,y:32996,varname:node_9684,prsc:2,v1:0.5;n:type:ShaderForge.SFN_Add,id:3304,x:32867,y:33032,varname:node_3304,prsc:2|A-9684-OUT,B-4681-OUT;n:type:ShaderForge.SFN_Tex2d,id:5042,x:33032,y:33032,ptovrint:False,ptlb:SpecularTex,ptin:_SpecularTex,varname:node_5042,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:4ce8f6efa46fa1340a802ff298aa1044,ntxv:0,isnm:False|UVIN-3304-OUT;proporder:9759-4844-9657-2982-2090-2644-4676-4709-8917-5227-7795-5042;pass:END;sub:END;*/

Shader "Oboro/WaterElement" {
    Properties {
        _MainTex ("MainTex", 2D) = "white" {}
        _FlowTex ("FlowTex", 2D) = "white" {}
        _FlowIntensity ("FlowIntensity", Float ) = 0.02
        _FlowSpeed ("FlowSpeed", Float ) = -0.1
        _MaskTex ("MaskTex", 2D) = "white" {}
        _WaveLength ("WaveLength", Float ) = 10
        _Frequency ("Frequency", Float ) = 1
        _Amplitude ("Amplitude", Float ) = 0.03
        _AlphaOffset ("AlphaOffset", Range(-1, 1)) = 0
        _CubeMap ("CubeMap", Cube) = "_Skybox" {}
        _RefrectionIntensity ("RefrectionIntensity", Float ) = 0.5
        _SpecularTex ("SpecularTex", 2D) = "white" {}
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        LOD 100
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
            #pragma multi_compile_fog
            #pragma exclude_renderers gles3 metal d3d11_9x xbox360 xboxone ps3 ps4 psp2 
            #pragma target 3.0
            #pragma glsl
            uniform float4 _TimeEditor;
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform sampler2D _FlowTex; uniform float4 _FlowTex_ST;
            uniform fixed _FlowIntensity;
            uniform float _FlowSpeed;
            uniform sampler2D _MaskTex; uniform float4 _MaskTex_ST;
            uniform fixed _WaveLength;
            uniform fixed _Frequency;
            uniform fixed _Amplitude;
            uniform float _AlphaOffset;
            uniform samplerCUBE _CubeMap;
            uniform float _RefrectionIntensity;
            uniform sampler2D _SpecularTex; uniform float4 _SpecularTex_ST;
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
                UNITY_FOG_COORDS(3)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                float4 objPos = mul ( _Object2World, float4(0,0,0,1) );
                float4 _MaskTex_var = tex2Dlod(_MaskTex,float4(TRANSFORM_TEX(o.uv0, _MaskTex),0.0,0));
                fixed4 node_4184 = _Time + _TimeEditor;
                v.vertex.xyz += (_MaskTex_var.r*(sin(((o.uv0.g*_WaveLength)+(node_4184.g*_Frequency)))+0.9)*_Amplitude*v.normal);
                o.posWorld = mul(_Object2World, v.vertex);
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                float4 objPos = mul ( _Object2World, float4(0,0,0,1) );
                i.normalDir = normalize(i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
                float3 viewReflectDirection = reflect( -viewDirection, normalDirection );
////// Lighting:
                float node_9684 = 0.5;
                float2 node_3304 = (node_9684+(node_9684*mul( UNITY_MATRIX_V, float4(i.normalDir,0) ).xyz.rgb.rg));
                float4 _SpecularTex_var = tex2D(_SpecularTex,TRANSFORM_TEX(node_3304, _SpecularTex));
                float4 node_3929 = _Time + _TimeEditor;
                float2 node_5791 = ((node_3929.g*_FlowSpeed)+i.uv0);
                float4 _FlowTex_var = tex2D(_FlowTex,TRANSFORM_TEX(node_5791, _FlowTex));
                float4 _MaskTex_var = tex2D(_MaskTex,TRANSFORM_TEX(i.uv0, _MaskTex));
                fixed2 node_255 = ((_FlowIntensity*_FlowTex_var.r*_MaskTex_var.r)+i.uv0);
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(node_255, _MainTex));
                float3 finalColor = (_SpecularTex_var.rgb+_MainTex_var.rgb+((1.0-max(0,dot(normalDirection, viewDirection)))*texCUBE(_CubeMap,viewReflectDirection).rgb*_RefrectionIntensity));
                fixed4 finalRGBA = fixed4(finalColor,((i.posWorld.g-objPos.g)+_AlphaOffset));
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
            #pragma glsl
            uniform float4 _TimeEditor;
            uniform sampler2D _MaskTex; uniform float4 _MaskTex_ST;
            uniform fixed _WaveLength;
            uniform fixed _Frequency;
            uniform fixed _Amplitude;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                V2F_SHADOW_CASTER;
                float2 uv0 : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                float4 _MaskTex_var = tex2Dlod(_MaskTex,float4(TRANSFORM_TEX(o.uv0, _MaskTex),0.0,0));
                fixed4 node_4184 = _Time + _TimeEditor;
                v.vertex.xyz += (_MaskTex_var.r*(sin(((o.uv0.g*_WaveLength)+(node_4184.g*_Frequency)))+0.9)*_Amplitude*v.normal);
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex );
                TRANSFER_SHADOW_CASTER(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3 normalDirection = i.normalDir;
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
