using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CommImageEffect : PostEffectsBase 
{
	public Shader Shader;

	private Material _mat;
	public Material Mat
	{
		get
		{
			_mat = CheckShaderAndCreateMaterial(Shader, _mat);
			return _mat;
		}
	}

	/// <summary>
	/// This function is called when the object becomes enabled and active.
	/// </summary>
	void OnEnable()
	{
		GetComponent<Camera>().depthTextureMode |= DepthTextureMode.Depth;
	}

	void OnRenderImage(RenderTexture src, RenderTexture dest)
	{
		if(_mat == null)
		{
			Graphics.Blit(src, dest);
		}
		else
		{
			_mat.SetTexture("_MainTex", src);

			Graphics.Blit(src, dest, _mat);
		}
	}
}
