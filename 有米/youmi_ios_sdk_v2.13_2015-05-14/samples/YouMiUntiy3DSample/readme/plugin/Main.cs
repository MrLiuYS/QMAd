using UnityEngine;
using System.Collections;

public class Main : MonoBehaviour {
	// Use this for initialization
	void Start () {

	}
	// Update is called once per frame
	void Update () {
		
	}
	
	void OnGUI() {
		if (GUI.Button(new Rect(20,44,150,60), "init wall")) {
			SpotSDK.InitSpot();
		}
		
		if (GUI.Button(new Rect(200, 44,150,60), "show wall")) {
			SpotSDK.ShowSpot();
		}
		
		GUI.Label (new Rect(100, 400, 320, 80), @"YouMi AD Unity3d Sample");
	}
}