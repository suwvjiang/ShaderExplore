using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CommImageEffect : PostEffectsBase 
{
	/// <summary>
	/// This function is called when the object becomes enabled and active.
	/// </summary>
	void OnEnable()
	{
		//GetComponent<Camera>().depthTextureMode |= DepthTextureMode.Depth;
	}

	void OnRenderImage(RenderTexture src, RenderTexture dest)
	{
		if(material == null)
		{
			Graphics.Blit(src, dest);
		}
		else
		{
			material.SetTexture("_MainTex", src);

			Graphics.Blit(src, dest, _mat);
		}
	}
}
