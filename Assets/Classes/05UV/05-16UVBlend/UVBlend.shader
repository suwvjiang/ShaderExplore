// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Shader created with Shader Forge v1.26 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.26;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:0,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0,fgcg:0.616,fgcb:1,fgca:1,fgde:0.01,fgrn:10,fgrf:100,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:8370,x:32580,y:32640,varname:node_8370,prsc:2|custl-4420-RGB;n:type:ShaderForge.SFN_TexCoord,id:7967,x:32016,y:32819,varname:node_7967,prsc:2,uv:0;n:type:ShaderForge.SFN_ScreenPos,id:1453,x:32016,y:32959,varname:node_1453,prsc:2,sctp:0;n:type:ShaderForge.SFN_Tex2d,id:4420,x:32404,y:32881,ptovrint:False,ptlb:MainTex,ptin:_MainTex,varname:node_4420,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:b50e5d65ddd51da42a75d7dc51e81102,ntxv:0,isnm:False|UVIN-3882-OUT;n:type:ShaderForge.SFN_Fresnel,id:5323,x:31695,y:33106,varname:node_5323,prsc:2|EXP-6165-OUT;n:type:ShaderForge.SFN_Vector1,id:6165,x:31526,y:33127,varname:node_6165,prsc:2,v1:1;n:type:ShaderForge.SFN_Step,id:6529,x:32016,y:33106,varname:node_6529,prsc:2|A-9137-OUT,B-7857-OUT;n:type:ShaderForge.SFN_Slider,id:7857,x:31701,y:33255,ptovrint:False,ptlb:Value,ptin:_Value,varname:node_7857,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.5299146,max:1;n:type:ShaderForge.SFN_Lerp,id:3882,x:32236,y:32881,varname:node_3882,prsc:2|A-7967-UVOUT,B-1453-UVOUT,T-6529-OUT;n:type:ShaderForge.SFN_OneMinus,id:9137,x:31858,y:33106,varname:node_9137,prsc:2|IN-5323-OUT;proporder:4420-7857;pass:END;sub:END;*/

Shader "Oboro/UVBlend" {
    Properties {
        _MainTex ("MainTex", 2D) = "white" {}
        _Value ("Value", Range(0, 1)) = 0.5299146
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
            #pragma multi_compile_fwdbase_fullshadows
            #pragma multi_compile_fog
            #pragma exclude_renderers gles3 metal d3d11_9x xbox360 xboxone ps3 ps4 psp2 
            #pragma target 3.0
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform float _Value;
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
                UNITY_FOG_COORDS(4)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos(v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                o.screenPos = o.pos;
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                i.screenPos = float4( i.screenPos.xy / i.screenPos.w, 0, 0 );
                i.screenPos.y *= _ProjectionParams.x;
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
////// Lighting:
                float2 node_3882 = lerp(i.uv0,i.screenPos.rg,step((1.0 - pow(1.0-max(0,dot(normalDirection, viewDirection)),1.0)),_Value));
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(node_3882, _MainTex));
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
