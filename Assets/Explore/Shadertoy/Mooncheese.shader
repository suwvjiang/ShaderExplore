// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Shadertoy/Mooncheese" 
{ 
    Properties
    {
        iMouse ("Mouse Pos", Vector) = (100, 100, 0, 0)
        iChannel0("iChannel0", 2D) = "white" {}  
        iChannelResolution0 ("iChannelResolution0", Vector) = (100, 100, 0, 0)
    }

    CGINCLUDE    
    #include "UnityCG.cginc"   
    #pragma target 3.0      

    #define vec2 float2
    #define vec3 float3
    #define vec4 float4
    #define mat2 float2x2
    #define mat3 float3x3
    #define mat4 float4x4
    #define iGlobalTime _Time.y
    #define mod fmod
    #define mix lerp
    #define fract frac
    #define texture2D tex2D
    #define iResolution _ScreenParams
    #define gl_FragCoord ((_iParam.scrPos.xy/_iParam.scrPos.w) * _ScreenParams.xy)

    #define PI2 6.28318530718
    #define PI 3.14159265358979
    #define halfpi (PI * 0.5)
    #define oneoverpi (1.0 / PI)

    fixed4 iMouse;
    sampler2D iChannel0;
    fixed4 iChannelResolution0;

    struct v2f 
    {    
        float4 pos : SV_POSITION;    
        float4 scrPos : TEXCOORD0;   
    };              

    vec2 sphere_map(vec3 n) 
    {
        return vec2((atan2(n.z,n.x)/(2.0 * PI)) + iGlobalTime * 0.05, acos(n.y) / (PI)) + vec2(0.6, 0.0);
    }

    float scene(vec3 position) 
    {
        vec2 uv = sphere_map(normalize(position));
        float height = 0.3 - pow(texture2D(iChannel0, uv).x, 3.0) * 0.1;
        return length(position)-height;
    }

    vec3 getNormal(vec3 ray_hit_position, float smoothness) 
    {   
        vec3 n;
        vec2 dn = vec2(smoothness, 0.0);
        n.x = scene(ray_hit_position + dn.xyy) - scene(ray_hit_position - dn.xyy);
        n.y = scene(ray_hit_position + dn.yxy) - scene(ray_hit_position - dn.yxy);
        n.z = scene(ray_hit_position + dn.yyx) - scene(ray_hit_position - dn.yyx);
        return normalize(n);
    } 

    float raymarch(vec3 position, vec3 direction) 
    {
        float total_distance = 0.0;
        for(int i = 0 ; i < 32 ; ++i) 
        {
            float result = scene(position + direction * total_distance);
            if(result < 0.005)
            {
                return total_distance;
            }
            total_distance += result;
        }
        return -1.0;
    }

    vec4 main(vec2 fragCoord) 
    {
        vec4 fragColor;

        vec2 uv = fragCoord.xy / iResolution.y;
        uv -= vec2(0.5*iResolution.x/iResolution.y, 0.5);
        vec3 direction = normalize(vec3(uv, 2.5));
        vec3 origin = vec3(0.0, 0.0, -2.5);
        float dist = raymarch(origin, direction);
        if(dist < 0.0) 
        {
            fragColor = vec4(0.0, sin(uv.y+1.0)*0.2, sin(uv.y+1.0)*0.3 ,1.0);
        } 
        else
        {
            vec3 fragPosition = origin+direction*dist;
            vec3 N = getNormal(fragPosition, 0.01);
            vec3 lightPos = vec3(1.0, 0.0, -1.0);
            float diffuse = dot(normalize(lightPos), N);
            diffuse = max(0.0, diffuse); 
            vec2 uv = sphere_map(normalize(fragPosition));
            vec4 cheeseColor = vec4(0.7, 0.8, 0.0, 1.0) - texture2D(iChannel0, uv).x * vec4(0.9, 0.55, 0.9, 1.0);
            fragColor = (cheeseColor*diffuse)+
                vec4(0.2, 0.0, 0.05, 1.0)+
                pow(max(0.0,dot(normalize(-reflect(fragPosition-lightPos, N)),normalize(-fragPosition))), 80.0) ;
        }
        return fragColor;
    }

    v2f vert(appdata_base v) 
    {  
        v2f o;
        o.pos = UnityObjectToClipPos (v.vertex);
        o.scrPos = ComputeScreenPos(o.pos);
        return o;
    }  

    vec4 main(vec2 fragCoord);

    fixed4 frag(v2f _iParam) : COLOR0 
    { 
        vec2 fragCoord = gl_FragCoord;
        return main(gl_FragCoord);
    } 

    ENDCG    

    SubShader 
    {    
        Pass 
        {    
            CGPROGRAM    

            #pragma vertex vert    
            #pragma fragment frag    
            #pragma fragmentoption ARB_precision_hint_fastest     

            ENDCG    
        }    
    }     
    FallBack Off    
}