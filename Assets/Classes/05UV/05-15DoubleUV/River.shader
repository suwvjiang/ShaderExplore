// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Shader created with Shader Forge v1.26 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.26;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:0,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:3,bdst:7,dpts:2,wrdp:False,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:False,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0,fgcg:0.616,fgcb:1,fgca:1,fgde:0.01,fgrn:10,fgrf:100,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:1769,x:33226,y:33061,varname:node_1769,prsc:2|custl-6827-RGB,alpha-2699-OUT;n:type:ShaderForge.SFN_Tex2d,id:6827,x:32689,y:33035,ptovrint:False,ptlb:MainTex,ptin:_MainTex,varname:node_6827,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:3a9827e5c0fbc6e47826a509282e99a4,ntxv:0,isnm:False|UVIN-6854-OUT;n:type:ShaderForge.SFN_Tex2d,id:3912,x:32025,y:33025,ptovrint:False,ptlb:FlowMap,ptin:_FlowMap,varname:node_3912,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:c1b38a07a3a28ac49bfb34dcfeae2381,ntxv:0,isnm:False|UVIN-262-OUT;n:type:ShaderForge.SFN_Append,id:2934,x:32192,y:33042,varname:node_2934,prsc:2|A-3912-R,B-3912-G;n:type:ShaderForge.SFN_Multiply,id:4067,x:32353,y:33042,varname:node_4067,prsc:2|A-2934-OUT,B-3864-OUT;n:type:ShaderForge.SFN_ValueProperty,id:3864,x:32192,y:33180,ptovrint:False,ptlb:FlowIntensity,ptin:_FlowIntensity,varname:node_3864,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0.01;n:type:ShaderForge.SFN_Add,id:6854,x:32513,y:33002,cmnt:从左边到这里是基本的UV流动节点树 视频中用偏移器节点简单替代,varname:node_6854,prsc:2|A-2132-OUT,B-7779-UVOUT,C-4067-OUT;n:type:ShaderForge.SFN_TexCoord,id:7779,x:31534,y:32895,varname:node_7779,prsc:2,uv:0;n:type:ShaderForge.SFN_Time,id:8189,x:31356,y:33043,varname:node_8189,prsc:2;n:type:ShaderForge.SFN_Multiply,id:653,x:31534,y:33043,varname:node_653,prsc:2|A-3093-OUT,B-8189-T;n:type:ShaderForge.SFN_Multiply,id:3898,x:31534,y:33164,varname:node_3898,prsc:2|A-8189-T,B-5269-OUT;n:type:ShaderForge.SFN_ValueProperty,id:3093,x:31356,y:32995,ptovrint:False,ptlb:USpeed,ptin:_USpeed,varname:node_3093,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_ValueProperty,id:5269,x:31356,y:33186,ptovrint:False,ptlb:VSpeed,ptin:_VSpeed,varname:node_5269,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Append,id:9767,x:31699,y:33043,varname:node_9767,prsc:2|A-653-OUT,B-3898-OUT;n:type:ShaderForge.SFN_Add,id:262,x:31864,y:33025,varname:node_262,prsc:2|A-7779-UVOUT,B-9767-OUT;n:type:ShaderForge.SFN_TexCoord,id:6756,x:32530,y:33331,varname:node_6756,prsc:2,uv:1;n:type:ShaderForge.SFN_Tex2d,id:9987,x:32689,y:33331,ptovrint:False,ptlb:AlphaMap,ptin:_AlphaMap,varname:node_9987,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:ad8fb56edb3a9904ab91eaabed2a3c1c,ntxv:0,isnm:False|UVIN-6756-UVOUT;n:type:ShaderForge.SFN_Multiply,id:2132,x:31864,y:32831,cmnt:这里让MainTex贴图反向偏移 不然流动效果太弱,varname:node_2132,prsc:2|A-9011-OUT,B-9767-OUT;n:type:ShaderForge.SFN_ValueProperty,id:9011,x:31677,y:32797,ptovrint:False,ptlb:TexSpeed,ptin:_TexSpeed,cmnt:参数设置为0 MainTex贴图不流动,varname:node_9011,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:-0.5;n:type:ShaderForge.SFN_Multiply,id:2699,x:32860,y:33348,cmnt:这里添加了整体控制透明程度的功能,varname:node_2699,prsc:2|A-9987-R,B-4690-OUT;n:type:ShaderForge.SFN_Slider,id:4690,x:32532,y:33506,ptovrint:False,ptlb:Alpha,ptin:_Alpha,varname:node_4690,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.5,max:1;n:type:ShaderForge.SFN_Vector1,id:4139,x:31158,y:32867,cmnt:节点树太长了 所以视频教学中没有使用UV流动,varname:node_4139,prsc:2,v1:0;n:type:ShaderForge.SFN_Vector1,id:5132,x:32689,y:33230,cmnt:注意 材质球 中每个贴图的重复值,varname:node_5132,prsc:2,v1:0;n:type:ShaderForge.SFN_Vector1,id:6821,x:31158,y:32702,cmnt:有时要关闭天空盒子才能看到透明效果,varname:node_6821,prsc:2,v1:0;n:type:ShaderForge.SFN_Vector1,id:3255,x:31158,y:32780,cmnt:切换为河流模型时 一开始可能看不见 要尝试多旋转一下视角,varname:node_3255,prsc:2,v1:0;proporder:6827-3912-9987-4690-3864-3093-5269-9011;pass:END;sub:END;*/

Shader "Oboro/River" {
    Properties {
        _MainTex ("MainTex", 2D) = "white" {}
        _FlowMap ("FlowMap", 2D) = "white" {}
        _AlphaMap ("AlphaMap", 2D) = "white" {}
        _Alpha ("Alpha", Range(0, 1)) = 0.5
        _FlowIntensity ("FlowIntensity", Float ) = 0.01
        _USpeed ("USpeed", Float ) = 1
        _VSpeed ("VSpeed", Float ) = 0
        _TexSpeed ("TexSpeed", Float ) = -0.5
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
            uniform float4 _TimeEditor;
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform sampler2D _FlowMap; uniform float4 _FlowMap_ST;
            uniform float _FlowIntensity;
            uniform float _USpeed;
            uniform float _VSpeed;
            uniform sampler2D _AlphaMap; uniform float4 _AlphaMap_ST;
            uniform float _TexSpeed;
            uniform float _Alpha;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float2 uv1 : TEXCOORD1;
                UNITY_FOG_COORDS(2)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.uv1 = v.texcoord1;
                o.pos = UnityObjectToClipPos(v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
////// Lighting:
                float4 node_8189 = _Time + _TimeEditor;
                float2 node_9767 = float2((_USpeed*node_8189.g),(node_8189.g*_VSpeed));
                float2 node_262 = (i.uv0+node_9767);
                float4 _FlowMap_var = tex2D(_FlowMap,TRANSFORM_TEX(node_262, _FlowMap));
                float2 node_6854 = ((_TexSpeed*node_9767)+i.uv0+(float2(_FlowMap_var.r,_FlowMap_var.g)*_FlowIntensity)); // 从左边到这里是基本的UV流动节点树 视频中用偏移器节点简单替代
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(node_6854, _MainTex));
                float3 finalColor = _MainTex_var.rgb;
                float4 _AlphaMap_var = tex2D(_AlphaMap,TRANSFORM_TEX(i.uv1, _AlphaMap));
                fixed4 finalRGBA = fixed4(finalColor,(_AlphaMap_var.r*_Alpha));
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
