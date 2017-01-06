// Shader created with Shader Forge v1.26 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.26;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:0,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0,fgcg:0.6689653,fgcb:1,fgca:1,fgde:0.01,fgrn:20,fgrf:100,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:1391,x:32981,y:32902,varname:node_1391,prsc:2|diff-9558-OUT;n:type:ShaderForge.SFN_Tex2d,id:4845,x:32377,y:32762,ptovrint:False,ptlb:MainTex1,ptin:_MainTex1,varname:node_4845,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:231cc28d8a340ee43a09a70ed505d70c,ntxv:0,isnm:False|UVIN-7177-UVOUT;n:type:ShaderForge.SFN_Tex2d,id:1499,x:32377,y:32957,ptovrint:False,ptlb:MainTex2,ptin:_MainTex2,varname:node_1499,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:018e926b9c6d03348b7b3e9e20d464a0,ntxv:0,isnm:False|UVIN-7177-UVOUT;n:type:ShaderForge.SFN_Tex2d,id:7294,x:32377,y:33149,ptovrint:False,ptlb:BlendMap,ptin:_BlendMap,varname:node_7294,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-7177-UVOUT;n:type:ShaderForge.SFN_Lerp,id:3980,x:32616,y:32902,varname:node_3980,prsc:2|A-4845-RGB,B-1499-RGB,T-7294-R;n:type:ShaderForge.SFN_TexCoord,id:7177,x:32101,y:32942,varname:node_7177,prsc:2,uv:0;n:type:ShaderForge.SFN_AmbientLight,id:1673,x:32616,y:33030,varname:node_1673,prsc:2;n:type:ShaderForge.SFN_Add,id:9558,x:32805,y:32902,varname:node_9558,prsc:2|A-3980-OUT,B-1673-RGB,C-3897-RGB;n:type:ShaderForge.SFN_Color,id:3897,x:32616,y:33190,ptovrint:False,ptlb:MainColor,ptin:_MainColor,varname:node_3897,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0,c2:0,c3:0,c4:1;proporder:3897-4845-1499-7294;pass:END;sub:END;*/

Shader "Oboro/Ground" {
    Properties {
        _MainColor ("MainColor", Color) = (0,0,0,1)
        _MainTex1 ("MainTex1", 2D) = "white" {}
        _MainTex2 ("MainTex2", 2D) = "white" {}
        _BlendMap ("BlendMap", 2D) = "white" {}
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
            uniform sampler2D _MainTex1; uniform float4 _MainTex1_ST;
            uniform sampler2D _MainTex2; uniform float4 _MainTex2_ST;
            uniform sampler2D _BlendMap; uniform float4 _BlendMap_ST;
            uniform float4 _MainColor;
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
                float3 lightColor = _LightColor0.rgb;
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex );
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
                float4 _MainTex1_var = tex2D(_MainTex1,TRANSFORM_TEX(i.uv0, _MainTex1));
                float4 _MainTex2_var = tex2D(_MainTex2,TRANSFORM_TEX(i.uv0, _MainTex2));
                float4 _BlendMap_var = tex2D(_BlendMap,TRANSFORM_TEX(i.uv0, _BlendMap));
                float3 diffuseColor = (lerp(_MainTex1_var.rgb,_MainTex2_var.rgb,_BlendMap_var.r)+UNITY_LIGHTMODEL_AMBIENT.rgb+_MainColor.rgb);
                float3 diffuse = (directDiffuse + indirectDiffuse) * diffuseColor;
/// Final Color:
                float3 finalColor = diffuse;
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
