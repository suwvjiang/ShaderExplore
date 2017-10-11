using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// 场景置灰
/// design by jiangchufei@gmail.com
/// date:2017-10-9
/// </summary> 

public class SceneGray : MonoBehaviour 
{
	public Transform Origin;
	[Range(0, 1)]
	public float Threshold;

	private MeshFilter[] _subMesh;
	private Renderer[] _subRender;

	// Use this for initialization
	void Start () 
	{
		InitSceneInfo();
	}
	
	// Update is called once per frame
	void Update () 
	{
		for(int i = 0; i < _subRender.Length; ++i)
		{
			Renderer render = _subRender[i];
			for(int j = 0; j < render.sharedMaterials.Length; ++j)
			{
				Material mat = render.sharedMaterials[j];
				if(mat == null)
					continue;

				mat.SetFloat("_Threshold", Threshold);
			}
		}
	}

	private void InitSceneInfo()
	{
		float maxDis = GetMaxDistance();
		UpdateProperty("_MaxDistance", maxDis);
	}

	private float GetMaxDistance()
	{
		Vector3 origin = Origin != null ? Origin.position : Vector3.zero;
		float maxDis = 0;

		if(_subMesh == null)
			_subMesh = GetComponentsInChildren<MeshFilter>();

		for(int i = 0; i < _subMesh.Length; ++i)
		{
			MeshFilter mf = _subMesh[i];
			for(int j = 0; j < mf.sharedMesh.vertexCount; ++j)
			{
				Vector3 vectex = mf.transform.TransformVector(mf.sharedMesh.vertices[j]);
				float dis = Vector3.Distance(origin, vectex);
				if(dis > maxDis)
					maxDis = dis;
			}
		}
		return maxDis;
	}

	private void UpdateProperty(string key, float value)
	{
		Vector3 origin = Origin != null ? Origin.position : Vector3.zero;

		if(_subRender == null)
			_subRender = GetComponentsInChildren<Renderer>();

		for(int i = 0; i < _subRender.Length; ++i)
		{
			Renderer render = _subRender[i];
			for(int j = 0; j < render.sharedMaterials.Length; ++j)
			{
				Material mat = render.sharedMaterials[j];
				if(mat == null)
					continue;

				mat.SetFloat(key, value);
				mat.SetVector("_Origin", origin);
			}
		}
	}
}
