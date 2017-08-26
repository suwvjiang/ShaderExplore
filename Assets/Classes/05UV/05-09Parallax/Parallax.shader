// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Shader created with Shader Forge v1.26 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.26;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:0,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:6832,x:32719,y:32712,varname:node_6832,prsc:2|custl-3277-RGB;n:type:ShaderForge.SFN_Tex2d,id:3277,x:32534,y:32954,ptovrint:False,ptlb:MainTex,ptin:_MainTex,varname:node_3277,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-1569-UVOUT;n:type:ShaderForge.SFN_Parallax,id:1569,x:32360,y:32954,varname:node_1569,prsc:2|UVIN-902-OUT,HEI-6638-OUT;n:type:ShaderForge.SFN_Slider,id:6638,x:31966,y:33268,ptovrint:False,ptlb:Parallax,ptin:_Parallax,varname:node_6638,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:-5,cur:0,max:5;n:type:ShaderForge.SFN_TexCoord,id:7820,x:31820,y:32954,varname:node_7820,prsc:2,uv:0;n:type:ShaderForge.SFN_Multiply,id:7792,x:32001,y:32954,varname:node_7792,prsc:2|A-7820-UVOUT,B-2495-OUT;n:type:ShaderForge.SFN_Multiply,id:3106,x:31820,y:33173,varname:node_3106,prsc:2|A-2198-OUT,B-2495-OUT;n:type:ShaderForge.SFN_Vector1,id:2198,x:31820,y:33103,varname:node_2198,prsc:2,v1:0.5;n:type:ShaderForge.SFN_Subtract,id:3674,x:32001,y:33092,varname:node_3674,prsc:2|A-2198-OUT,B-3106-OUT;n:type:ShaderForge.SFN_Add,id:902,x:32171,y:32954,cmnt:这里对UV进行了中心缩放,varname:node_902,prsc:2|A-7792-OUT,B-3674-OUT;n:type:ShaderForge.SFN_Slider,id:2495,x:31427,y:33092,ptovrint:False,ptlb:Scale,ptin:_Scale,varname:node_4701,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:1,max:8;proporder:3277-6638-2495;pass:END;sub:END;*/

Shader "Oboro/Parallax" {
    Properties {
        _MainTex ("MainTex", 2D) = "white" {}
        _Parallax ("Parallax", Range(-5, 5)) = 0
        _Scale ("Scale", Range(0, 8)) = 1
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
            uniform float _Parallax;
            uniform float _Scale;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float3 tangentDir : TEXCOORD3;
                float3 bitangentDir : TEXCOORD4;
                UNITY_FOG_COORDS(5)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.tangentDir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos(v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
////// Lighting:
                float node_2198 = 0.5;
                float2 node_1569 = (0.05*(_Parallax - 0.5)*mul(tangentTransform, viewDirection).xy + ((i.uv0*_Scale)+(node_2198-(node_2198*_Scale))));
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(node_1569.rg, _MainTex));
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
