using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// 
/// design by jiangchufei@gmail.com
/// date:2017
/// </summary> 

public class EdgePostEffect : PostEffectsBase 
{
	[Range(0.0f, 1.0f)]
	public float EdgeOnly = 0f;
	public Color EdgeColor = Color.white;
	public Color BackgroundColor = Color.black;
	public float SampleDistance = 1.0f;
	[Range(0, 0.5f)]
	public float SensitivityDepth = 0.5f;
	[Range(0, 0.5f)]
	public float SensitivityNormal = 0.5f;

	/// <summary>
	/// This function is called when the object becomes enabled and active.
	/// </summary>
	void OnEnable()
	{
		GetComponent<Camera>().depthTextureMode |= DepthTextureMode.DepthNormals;
	}

	/// <summary>
	/// OnRenderImage is called after all rendering is complete to render image.
	/// </summary>
	/// <param name="src">The source RenderTexture.</param>
	/// <param name="dest">The destination RenderTexture.</param>
	[ImageEffectOpaque]
	void OnRenderImage(RenderTexture src, RenderTexture dest)
	{
		if(material == null)
		{
			Graphics.Blit(src, dest);
		}
		else
		{
			material.SetTexture("_MainTex", src);
			material.SetColor("_EdgeColor", EdgeColor);
			material.SetColor("_BackgroundColor", BackgroundColor);
			material.SetFloat("_EdgeOnly", EdgeOnly);
			material.SetFloat("_SampleDistance", SampleDistance);
			material.SetVector("_Sensitivity", new Vector2(SensitivityNormal, SensitivityDepth));

			Graphics.Blit(src, dest, material);
		}
	}
}
