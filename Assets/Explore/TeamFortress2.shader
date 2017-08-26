Shader "Explore/TF2"
{
	Properties
	{
		_MainTex("base(rgb)", 2D) = "white"{}
		_RampTex ("Ramp Tex", 2D) = "white" {}
		_DiffuseCube("Cube", Cube) = "white"{}
		_Amount("Amount", Range(0,1)) = 1
		_RimColor("Rim Color", Color) = (0.26, 0.19, 0.16, 0.0)
		_RimPower("Rim Power", Range(0.5, 8.0)) = 3.0
		_SpecularColor("Specular Color", Color) = (1,1,1,1)
		_SpecularPower("Specular Power", Range(0, 30)) = 1
		_SpecularFresnel("Specular Fresnel", Range(0,1)) = 0.5
	}

	SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf NoLight
		#pragma target 3.0 

		sampler2D _MainTex;
		sampler2D _RampTex;
		samplerCUBE _DiffuseCube;

		float _Amount;
		float3 _RimColor;
		float _RimPower;
		float3 _SpecularColor;
		float _SpecularPower;
		float _SpecularFresnel;

		inline float4 LightingNoLight(SurfaceOutput s, fixed3 lightDir, fixed3 viewDir, fixed3 atten)
		{
			float4 col;
			//Half-Lambert
			fixed halfLambert  = 0.5 * dot(s.Normal, lightDir) + 0.5;
			half3 ramp = tex2D(_RampTex, fixed2(halfLambert, 0)).rgb;

			half3 cube = texCUBE(_DiffuseCube, s.Normal).rgb * _Amount;

			//Blinn-Phong
			half3 halfVec = normalize(lightDir + viewDir);
			half spec = pow(max(0,dot(halfVec, s.Normal)),_SpecularPower);
			half fresnel = 1.0 - dot(viewDir, halfVec);
			fresnel = pow(fresnel, 5.0);
			fresnel += _SpecularFresnel*(1.0-fresnel);
			half3 finalSpec = _SpecularColor * spec * fresnel * _LightColor0.rgb;

			col.rgb = finalSpec + s.Albedo*(ramp + cube);
			col.a = s.Alpha;
			return col;
		}

		struct Input
		{ 
			float2 uv_MainTex;
			float3 viewDir;
		};

		void surf(Input IN, inout SurfaceOutput o)
		{
			half4 c = tex2D(_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;

			half rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));
			o.Emission = _RimColor.rgb * pow(rim, _RimPower);

			o.Alpha = c.a;
		}

		ENDCG
	}
	FallBack "Diffuse"
}