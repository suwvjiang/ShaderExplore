// Shader created with Shader Forge v1.26 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.26;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:0,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:1468,x:33042,y:32727,varname:node_1468,prsc:2|custl-8122-OUT;n:type:ShaderForge.SFN_Tex2d,id:9762,x:32483,y:32831,ptovrint:False,ptlb:MainTex,ptin:_MainTex,varname:node_9762,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_LightVector,id:2680,x:31940,y:32907,varname:node_2680,prsc:2;n:type:ShaderForge.SFN_NormalVector,id:9843,x:31940,y:33051,prsc:2,pt:False;n:type:ShaderForge.SFN_Dot,id:9841,x:32132,y:32988,varname:node_9841,prsc:2,dt:0|A-2680-OUT,B-9843-OUT;n:type:ShaderForge.SFN_LightColor,id:1604,x:32489,y:33111,varname:node_1604,prsc:2;n:type:ShaderForge.SFN_Multiply,id:8122,x:32691,y:32966,varname:node_8122,prsc:2|A-9762-RGB,B-6520-OUT;n:type:ShaderForge.SFN_AmbientLight,id:410,x:32489,y:33250,varname:node_410,prsc:2;n:type:ShaderForge.SFN_Add,id:9288,x:32862,y:32966,varname:node_9288,prsc:2|A-8122-OUT,B-4980-OUT;n:type:ShaderForge.SFN_Multiply,id:4980,x:32685,y:33250,varname:node_4980,prsc:2|A-410-RGB,B-5387-OUT;n:type:ShaderForge.SFN_Slider,id:5387,x:32332,y:33405,ptovrint:False,ptlb:Ambient,ptin:_Ambient,varname:node_5387,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:1,max:1;n:type:ShaderForge.SFN_Multiply,id:6952,x:32310,y:33014,varname:node_6952,prsc:2|A-9841-OUT,B-9632-OUT;n:type:ShaderForge.SFN_Slider,id:9632,x:31975,y:33231,ptovrint:False,ptlb:Power,ptin:_Power,varname:node_9632,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:1,cur:1,max:30;n:type:ShaderForge.SFN_Clamp01,id:6520,x:32489,y:32989,varname:node_6520,prsc:2|IN-6952-OUT;proporder:9762-5387-9632;pass:END;sub:END;*/

Shader "Unlit/DiffuseTest2" {
    Properties {
        _MainTex ("MainTex", 2D) = "white" {}
        _Ambient ("Ambient", Range(0, 1)) = 1
        _Power ("Power", Range(1, 30)) = 1
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
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform float _Power;
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
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(i.uv0, _MainTex));
                float3 node_8122 = (_MainTex_var.rgb*saturate((dot(lightDirection,i.normalDir)*_Power)));
                float3 finalColor = node_8122;
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
