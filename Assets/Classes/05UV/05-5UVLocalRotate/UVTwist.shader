// Shader created with Shader Forge v1.26 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.26;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:0,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:0,dpts:2,wrdp:False,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:6302,x:32719,y:32712,varname:node_6302,prsc:2|custl-7151-RGB;n:type:ShaderForge.SFN_Tex2d,id:7151,x:32532,y:32952,ptovrint:False,ptlb:MainTex,ptin:_MainTex,varname:node_7151,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-7453-UVOUT;n:type:ShaderForge.SFN_TexCoord,id:4826,x:31855,y:32945,varname:node_4826,prsc:2,uv:0;n:type:ShaderForge.SFN_Rotator,id:7453,x:32370,y:32952,varname:node_7453,prsc:2|UVIN-4826-UVOUT,ANG-3123-OUT;n:type:ShaderForge.SFN_Tex2d,id:1959,x:32012,y:32977,ptovrint:False,ptlb:TwistTex,ptin:_TwistTex,varname:node_1959,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-4826-UVOUT;n:type:ShaderForge.SFN_Multiply,id:3123,x:32188,y:33081,varname:node_3123,prsc:2|A-1959-R,B-2302-OUT,C-6497-OUT;n:type:ShaderForge.SFN_Slider,id:2302,x:31855,y:33147,ptovrint:False,ptlb:Twist,ptin:_Twist,varname:node_2302,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:-1,cur:0,max:1;n:type:ShaderForge.SFN_Vector1,id:6497,x:32012,y:33212,varname:node_6497,prsc:2,v1:5;n:type:ShaderForge.SFN_Vector1,id:9993,x:33073,y:33614,cmnt:注意 材质球 中每个贴图的重复值,varname:node_9993,prsc:2,v1:0;proporder:7151-1959-2302;pass:END;sub:END;*/

Shader "Oboro/UVTwist" {
    Properties {
        _MainTex ("MainTex", 2D) = "white" {}
        _TwistTex ("TwistTex", 2D) = "white" {}
        _Twist ("Twist", Range(-1, 1)) = 0
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        LOD 200
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend One One
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
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform sampler2D _TwistTex; uniform float4 _TwistTex_ST;
            uniform float _Twist;
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
                float4 _TwistTex_var = tex2D(_TwistTex,TRANSFORM_TEX(i.uv0, _TwistTex));
                float node_7453_ang = (_TwistTex_var.r*_Twist*5.0);
                float node_7453_spd = 1.0;
                float node_7453_cos = cos(node_7453_spd*node_7453_ang);
                float node_7453_sin = sin(node_7453_spd*node_7453_ang);
                float2 node_7453_piv = float2(0.5,0.5);
                float2 node_7453 = (mul(i.uv0-node_7453_piv,float2x2( node_7453_cos, -node_7453_sin, node_7453_sin, node_7453_cos))+node_7453_piv);
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(node_7453, _MainTex));
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
