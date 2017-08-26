// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Shader created with Shader Forge v1.26 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.26;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0,fgcg:1,fgcb:0.5862069,fgca:1,fgde:0.01,fgrn:0,fgrf:136.53,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:3089,x:32719,y:32712,varname:node_3089,prsc:2|custl-5380-OUT;n:type:ShaderForge.SFN_Tex2d,id:2347,x:32277,y:32814,ptovrint:False,ptlb:MainTex,ptin:_MainTex,varname:node_2347,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:733e65cc7b1452c4394177b71d9b57e0,ntxv:0,isnm:False;n:type:ShaderForge.SFN_RemapRangeAdvanced,id:5380,x:32545,y:32952,varname:node_5380,prsc:2|IN-2347-RGB,IMIN-50-OUT,IMAX-8564-OUT,OMIN-7556-OUT,OMAX-6956-OUT;n:type:ShaderForge.SFN_Slider,id:50,x:32120,y:32991,ptovrint:False,ptlb:iMin,ptin:_iMin,varname:node_50,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Slider,id:8564,x:32120,y:33081,ptovrint:False,ptlb:iMax,ptin:_iMax,varname:node_8564,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:1,max:1;n:type:ShaderForge.SFN_Slider,id:7556,x:32120,y:33172,ptovrint:False,ptlb:oMin,ptin:_oMin,varname:node_7556,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Slider,id:6956,x:32120,y:33255,ptovrint:False,ptlb:oMax,ptin:_oMax,varname:node_6956,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:1,max:1;proporder:2347-50-8564-7556-6956;pass:END;sub:END;*/

Shader "Oboro/Remap" {
    Properties {
        _MainTex ("MainTex", 2D) = "white" {}
        _iMin ("iMin", Range(0, 1)) = 0
        _iMax ("iMax", Range(0, 1)) = 1
        _oMin ("oMin", Range(0, 1)) = 0
        _oMax ("oMax", Range(0, 1)) = 1
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
            uniform float _iMin;
            uniform float _iMax;
            uniform float _oMin;
            uniform float _oMax;
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
                o.pos = UnityObjectToClipPos(v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
////// Lighting:
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(i.uv0, _MainTex));
                float3 finalColor = (_oMin + ( (_MainTex_var.rgb - _iMin) * (_oMax - _oMin) ) / (_iMax - _iMin));
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
