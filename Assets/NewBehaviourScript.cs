using UnityEngine;
using System.Collections;

public class NewBehaviourScript : MonoBehaviour {

	public Transform Cube;
	public Transform UI;

	private float Fomat;
	private Transform Head;

	void Start () 
	{
		Head = Cube.Find("head");
		Fomat  = Vector3.Distance(Head.position,Camera.main.transform.position);
	}
	
	void Update () 
	{
		float newFomat = Fomat / Vector3.Distance(Head.position,Camera.main.transform.position);
		UI.position  = WorldToUI(Head.position);
		UI.localScale = Vector3.one * newFomat;

		if(Input.GetKey(KeyCode.W))
			Cube.Translate(Vector3.forward);
		if(Input.GetKey(KeyCode.S))
			Cube.Translate(Vector3.back);
	}



	public static Vector3 WorldToUI(Vector3 point)
	{
		Vector3 pt = Camera.main.WorldToScreenPoint(point);
		Vector3 ff = 	UICamera.currentCamera.ScreenToWorldPoint(pt);
		ff.z = 0;
		return ff;
	}
}
