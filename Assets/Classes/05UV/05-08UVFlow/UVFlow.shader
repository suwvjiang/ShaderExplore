// Shader created with Shader Forge v1.26 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.26;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:0,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:525,x:32587,y:32725,varname:node_525,prsc:2|custl-9859-RGB;n:type:ShaderForge.SFN_Tex2d,id:9859,x:32424,y:32965,ptovrint:False,ptlb:MainTex,ptin:_MainTex,varname:node_9859,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:8258d23560c50a94eafef95307ede43d,ntxv:0,isnm:False|UVIN-3211-OUT;n:type:ShaderForge.SFN_Tex2d,id:8640,x:31762,y:33019,ptovrint:False,ptlb:FlowTex,ptin:_FlowTex,varname:node_8640,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:c1b38a07a3a28ac49bfb34dcfeae2381,ntxv:0,isnm:False|UVIN-8677-OUT;n:type:ShaderForge.SFN_TexCoord,id:8919,x:31288,y:32827,varname:node_8919,prsc:2,uv:0;n:type:ShaderForge.SFN_Append,id:787,x:31923,y:33033,varname:node_787,prsc:2|A-8640-R,B-8640-G;n:type:ShaderForge.SFN_Multiply,id:6515,x:32082,y:33033,varname:node_6515,prsc:2|A-787-OUT,B-1506-OUT,C-6241-OUT;n:type:ShaderForge.SFN_Slider,id:1506,x:31608,y:33204,ptovrint:False,ptlb:FlowIntensity,ptin:_FlowIntensity,varname:node_1506,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:-1,cur:0,max:1;n:type:ShaderForge.SFN_Vector1,id:6241,x:31765,y:33277,varname:node_6241,prsc:2,v1:0.1;n:type:ShaderForge.SFN_Add,id:3211,x:32262,y:32965,varname:node_3211,prsc:2|A-8919-UVOUT,B-6515-OUT;n:type:ShaderForge.SFN_Time,id:968,x:31113,y:33032,varname:node_968,prsc:2;n:type:ShaderForge.SFN_Multiply,id:5670,x:31288,y:32973,varname:node_5670,prsc:2|A-1294-OUT,B-968-T;n:type:ShaderForge.SFN_Multiply,id:6561,x:31288,y:33124,varname:node_6561,prsc:2|A-968-T,B-8523-OUT;n:type:ShaderForge.SFN_Append,id:6182,x:31449,y:33039,varname:node_6182,prsc:2|A-5670-OUT,B-6561-OUT;n:type:ShaderForge.SFN_Add,id:8677,x:31608,y:33019,varname:node_8677,prsc:2|A-8919-UVOUT,B-6182-OUT;n:type:ShaderForge.SFN_Slider,id:1294,x:30956,y:32961,ptovrint:False,ptlb:USpeed,ptin:_USpeed,varname:node_1294,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Slider,id:8523,x:30956,y:33182,ptovrint:False,ptlb:VSpeed,ptin:_VSpeed,varname:node_8523,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;proporder:9859-8640-1506-1294-8523;pass:END;sub:END;*/

Shader "Oboro/UVFlow" {
    Properties {
        _MainTex ("MainTex", 2D) = "white" {}
        _FlowTex ("FlowTex", 2D) = "white" {}
        _FlowIntensity ("FlowIntensity", Range(-1, 1)) = 0
        _USpeed ("USpeed", Range(0, 1)) = 0
        _VSpeed ("VSpeed", Range(0, 1)) = 0
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
            uniform float4 _TimeEditor;
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform sampler2D _FlowTex; uniform float4 _FlowTex_ST;
            uniform float _FlowIntensity;
            uniform float _USpeed;
            uniform float _VSpeed;
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
                float4 node_968 = _Time + _TimeEditor;
                float2 node_8677 = (i.uv0+float2((_USpeed*node_968.g),(node_968.g*_VSpeed)));
                float4 _FlowTex_var = tex2D(_FlowTex,TRANSFORM_TEX(node_8677, _FlowTex));
                float2 node_3211 = (i.uv0+(float2(_FlowTex_var.r,_FlowTex_var.g)*_FlowIntensity*0.1));
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(node_3211, _MainTex));
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
