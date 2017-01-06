// Shader created with Shader Forge v1.26 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.26;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:0,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0,fgcg:1,fgcb:0.5862069,fgca:1,fgde:0.01,fgrn:0,fgrf:136.53,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:9824,x:32685,y:32688,varname:node_9824,prsc:2|custl-1739-OUT;n:type:ShaderForge.SFN_Tex2d,id:66,x:32220,y:32855,ptovrint:False,ptlb:Tex1,ptin:_Tex1,varname:node_66,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:a976a85c4db9e2b4fb212b45c62d6cb0,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Tex2d,id:4991,x:32220,y:33036,ptovrint:False,ptlb:Tex2,ptin:_Tex2,varname:node_4991,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:6d520672284b6a24780329e5428743cc,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Tex2d,id:5682,x:32220,y:33226,ptovrint:False,ptlb:Tex3,ptin:_Tex3,varname:node_5682,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:1cbe4abf5894f404ea00c17846d8d57d,ntxv:0,isnm:False;n:type:ShaderForge.SFN_If,id:1739,x:32507,y:32928,varname:node_1739,prsc:2|A-3497-OUT,B-7910-OUT,GT-66-RGB,EQ-4991-RGB,LT-5682-RGB;n:type:ShaderForge.SFN_ValueProperty,id:3497,x:32223,y:32624,ptovrint:False,ptlb:A,ptin:_A,varname:node_3497,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Vector1,id:7910,x:32222,y:32719,varname:node_7910,prsc:2,v1:1;proporder:3497-66-4991-5682;pass:END;sub:END;*/

Shader "Oboro/If" {
    Properties {
        _A ("A", Float ) = 1
        _Tex1 ("Tex1", 2D) = "white" {}
        _Tex2 ("Tex2", 2D) = "white" {}
        _Tex3 ("Tex3", 2D) = "white" {}
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
            uniform sampler2D _Tex1; uniform float4 _Tex1_ST;
            uniform sampler2D _Tex2; uniform float4 _Tex2_ST;
            uniform sampler2D _Tex3; uniform float4 _Tex3_ST;
            uniform float _A;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                UNITY_FOG_COORDS(1)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
////// Lighting:
                float node_1739_if_leA = step(_A,1.0);
                float node_1739_if_leB = step(1.0,_A);
                float4 _Tex3_var = tex2D(_Tex3,TRANSFORM_TEX(i.uv0, _Tex3));
                float4 _Tex1_var = tex2D(_Tex1,TRANSFORM_TEX(i.uv0, _Tex1));
                float4 _Tex2_var = tex2D(_Tex2,TRANSFORM_TEX(i.uv0, _Tex2));
                float3 finalColor = lerp((node_1739_if_leA*_Tex3_var.rgb)+(node_1739_if_leB*_Tex1_var.rgb),_Tex2_var.rgb,node_1739_if_leA*node_1739_if_leB);
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
