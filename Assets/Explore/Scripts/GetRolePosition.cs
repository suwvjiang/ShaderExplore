using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// 
/// design by jiangchufei@gmail.com
/// date:2017-9-30
/// </summary> 

[ExecuteInEditMode]
public class GetRolePosition : MonoBehaviour 
{
	public Transform Role;

	private Material _mat;

	/// <summary>
	/// Awake is called when the script instance is being loaded.
	/// </summary>
	void Awake()
	{
		_mat = GetComponent<MeshRenderer>().sharedMaterial;

		if(Role != null)
			_mat.SetVector("_RolePos", Role.position);
	}
	
	// Update is called once per frame
	void Update () 
	{
		if(Role != null)
			_mat.SetVector("_RolePos", Role.position);
	}
}
