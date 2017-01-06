// Shader created with Shader Forge v1.26 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.26;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:3,bdst:7,dpts:2,wrdp:False,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:1,x:34757,y:32699,varname:node_1,prsc:2|custl-2-RGB,alpha-2-A;n:type:ShaderForge.SFN_Tex2d,id:2,x:34536,y:32712,ptovrint:False,ptlb:texture,ptin:_texture,cmnt:彩蛋  没有UVTile节点的时候实现序列动画的方法,varname:_texture,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:ab0096e3acd4cd746a00b4eebede5d4c,ntxv:0,isnm:False|UVIN-39-OUT;n:type:ShaderForge.SFN_TexCoord,id:14,x:33992,y:32712,varname:node_14,prsc:2,uv:0;n:type:ShaderForge.SFN_Divide,id:15,x:34173,y:32712,varname:node_15,prsc:2|A-14-UVOUT,B-47-OUT;n:type:ShaderForge.SFN_Time,id:19,x:32838,y:32973,varname:node_19,prsc:2;n:type:ShaderForge.SFN_Add,id:39,x:34353,y:32712,varname:node_39,prsc:2|A-15-OUT,B-66-OUT;n:type:ShaderForge.SFN_ValueProperty,id:46,x:33350,y:32857,ptovrint:False,ptlb:X,ptin:_X,varname:_X,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:4;n:type:ShaderForge.SFN_Append,id:47,x:33992,y:32861,varname:node_47,prsc:2|A-46-OUT,B-49-OUT;n:type:ShaderForge.SFN_ValueProperty,id:49,x:33144,y:32885,ptovrint:False,ptlb:Y,ptin:_Y,varname:_Y,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:2;n:type:ShaderForge.SFN_Divide,id:55,x:33798,y:32897,varname:node_55,prsc:2|A-62-OUT,B-46-OUT;n:type:ShaderForge.SFN_Ceil,id:56,x:34111,y:33234,cmnt:123456789,varname:node_56,prsc:2|IN-91-OUT;n:type:ShaderForge.SFN_Vector1,id:62,x:32930,y:33129,varname:node_62,prsc:2,v1:1;n:type:ShaderForge.SFN_Multiply,id:65,x:33992,y:33025,cmnt:X输出,varname:node_65,prsc:2|A-55-OUT,B-95-OUT;n:type:ShaderForge.SFN_Append,id:66,x:34186,y:33025,cmnt:动画,varname:node_66,prsc:2|A-65-OUT,B-74-OUT;n:type:ShaderForge.SFN_Divide,id:70,x:33472,y:33294,varname:node_70,prsc:2|A-62-OUT,B-49-OUT;n:type:ShaderForge.SFN_Subtract,id:74,x:34493,y:33170,cmnt:y输出,varname:node_74,prsc:2|A-62-OUT,B-82-OUT;n:type:ShaderForge.SFN_Multiply,id:82,x:34307,y:33204,varname:node_82,prsc:2|A-70-OUT,B-56-OUT;n:type:ShaderForge.SFN_Divide,id:91,x:33806,y:33240,cmnt:Y时间u输入,varname:node_91,prsc:2|A-117-OUT,B-46-OUT;n:type:ShaderForge.SFN_Floor,id:95,x:33820,y:33047,cmnt:X时间输入,varname:node_95,prsc:2|IN-117-OUT;n:type:ShaderForge.SFN_Multiply,id:110,x:33446,y:32988,varname:node_110,prsc:2|A-121-OUT,B-111-OUT;n:type:ShaderForge.SFN_ValueProperty,id:111,x:33277,y:33181,ptovrint:False,ptlb:FPS,ptin:_FPS,varname:_FPS,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:2;n:type:ShaderForge.SFN_SwitchProperty,id:117,x:33642,y:33031,ptovrint:False,ptlb:ctrltime,ptin:_ctrltime,varname:_ctrltime,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,on:False|A-110-OUT,B-131-OUT;n:type:ShaderForge.SFN_Add,id:118,x:33058,y:33193,varname:node_118,prsc:2|A-19-T,B-119-OUT;n:type:ShaderForge.SFN_ValueProperty,id:119,x:32867,y:33297,ptovrint:False,ptlb:startframenum,ptin:_startframenum,varname:_startframenum,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_SwitchProperty,id:121,x:33277,y:32988,ptovrint:False,ptlb:startframe,ptin:_startframe,varname:_startframe,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,on:False|A-19-T,B-118-OUT;n:type:ShaderForge.SFN_ValueProperty,id:131,x:33471,y:33201,ptovrint:False,ptlb:time,ptin:_time,varname:_time,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;proporder:2-46-49-111-117-131-121-119;pass:END;sub:END;*/

Shader "Shader Forge/frame" {
    Properties {
        _texture ("texture", 2D) = "white" {}
        _X ("X", Float ) = 4
        _Y ("Y", Float ) = 2
        _FPS ("FPS", Float ) = 2
        [MaterialToggle] _ctrltime ("ctrltime", Float ) = 0
        _time ("time", Float ) = 0
        [MaterialToggle] _startframe ("startframe", Float ) = 0
        _startframenum ("startframenum", Float ) = 0
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend SrcAlpha OneMinusSrcAlpha
            Cull Off
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma multi_compile_fog
            #pragma exclude_renderers xbox360 xboxone ps3 ps4 psp2 
            #pragma target 3.0
            uniform float4 _TimeEditor;
            uniform sampler2D _texture; uniform float4 _texture_ST;
            uniform float _X;
            uniform float _Y;
            uniform float _FPS;
            uniform fixed _ctrltime;
            uniform float _startframenum;
            uniform fixed _startframe;
            uniform float _time;
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
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
////// Lighting:
                float node_62 = 1.0;
                float4 node_19 = _Time + _TimeEditor;
                float _ctrltime_var = lerp( (lerp( node_19.g, (node_19.g+_startframenum), _startframe )*_FPS), _time, _ctrltime );
                float2 node_39 = ((i.uv0/float2(_X,_Y))+float2(((node_62/_X)*floor(_ctrltime_var)),(node_62-((node_62/_Y)*ceil((_ctrltime_var/_X))))));
                float4 _texture_var = tex2D(_texture,TRANSFORM_TEX(node_39, _texture)); // 彩蛋  没有UVTile节点的时候实现序列动画的方法
                float3 finalColor = _texture_var.rgb;
                fixed4 finalRGBA = fixed4(finalColor,_texture_var.a);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
