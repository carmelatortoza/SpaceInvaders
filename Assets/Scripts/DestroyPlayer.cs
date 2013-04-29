using UnityEngine;
using System.Collections;

public class DestroyPlayer : MonoBehaviour {
	
	public AudioClip sfx;
	
	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
	
	}
	
	void OnTriggerEnter(Collider col){
		if(col.tag == "Bullets"){
			AudioSource.PlayClipAtPoint(sfx, Vector3.right);
			col.gameObject.SetActive(false);
			gameObject.SetActive(false);
		}
		if(col.tag == "Boundaries"){
			gameObject.SetActive(false);
		}
	}
}
