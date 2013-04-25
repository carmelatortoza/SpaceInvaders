using UnityEngine;
using System.Collections;

public class MainMenu : MonoBehaviour {

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
	
	}
	
	void OnGUI(){
		if(GUI.Button(new Rect(240, 160, 80, 20), "Start")){
			Application.LoadLevel(1);
		}
	}
}
