// Shader created with Shader Forge v1.26 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.26;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:0,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:2215,x:32841,y:32712,varname:node_2215,prsc:2|custl-8607-RGB;n:type:ShaderForge.SFN_Tex2d,id:8607,x:32621,y:32949,ptovrint:False,ptlb:MainTex,ptin:_MainTex,varname:node_8607,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:82a884a835cc7ab45b31286d56969ba9,ntxv:2,isnm:False|UVIN-2275-OUT;n:type:ShaderForge.SFN_NormalVector,id:9820,x:31776,y:32949,prsc:2,pt:False;n:type:ShaderForge.SFN_Transform,id:4819,x:31935,y:32949,varname:node_4819,prsc:2,tffrom:0,tfto:3|IN-9820-OUT;n:type:ShaderForge.SFN_ComponentMask,id:8202,x:32095,y:32949,varname:node_8202,prsc:2,cc1:0,cc2:1,cc3:-1,cc4:-1|IN-4819-XYZ;n:type:ShaderForge.SFN_Multiply,id:4779,x:32289,y:32949,varname:node_4779,prsc:2|A-8202-OUT,B-9203-OUT;n:type:ShaderForge.SFN_Vector1,id:9203,x:32095,y:33094,varname:node_9203,prsc:2,v1:0.5;n:type:ShaderForge.SFN_Add,id:2275,x:32455,y:32949,varname:node_2275,prsc:2|A-4779-OUT,B-9203-OUT;proporder:8607;pass:END;sub:END;*/

Shader "Oboro/NormalTransformUV" {
    Properties {
        _MainTex ("MainTex", 2D) = "black" {}
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
            #pragma multi_compile_fwdbase_fullshadows
            #pragma multi_compile_fog
            #pragma exclude_renderers gles3 metal d3d11_9x xbox360 xboxone ps3 ps4 psp2 
            #pragma target 3.0
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float3 normalDir : TEXCOORD0;
                UNITY_FOG_COORDS(1)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3 normalDirection = i.normalDir;
////// Lighting:
                float node_9203 = 0.5;
                float2 node_2275 = ((mul( UNITY_MATRIX_V, float4(i.normalDir,0) ).xyz.rgb.rg*node_9203)+node_9203);
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(node_2275, _MainTex));
                float3 finalColor = _MainTex_var.rgb;
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
