using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
///
/// design by jiangchufei@gmail.com
/// date:2017-9-3
/// </summary> 

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class ExplorePostEffectBase : MonoBehaviour 
{
	protected void CheckResources()
	{
		bool isSupported = CheckSupport();
		if(!isSupported)
			NotSupported();
	}

	protected bool CheckSupport()
	{
		if(!SystemInfo.supportsImageEffects)
		{
			Debug.LogWarning("this platform does not support image effects");
			return false;
		}
		return true;
	}

	protected void NotSupported()
	{
		enabled = false;
	}
	// Use this for initialization
	protected void Start () 
	{
		CheckResources();
	}

	protected Material CheckShaderAndCreateMaterial(Shader shader, Material mat)
	{
		if(shader == null)
			return null;
		
		if(shader.isSupported && mat && mat.shader == shader)
			return mat;

		if(!shader.isSupported)
			return null;
		else
		{
			mat = new Material(shader);
			mat.hideFlags = HideFlags.DontSave;
			if(mat)
				return mat;
			else
				return null;
		}
	}
}
