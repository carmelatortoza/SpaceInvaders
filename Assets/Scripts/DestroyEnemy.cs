using UnityEngine;
using System.Collections;

public class DestroyEnemy : MonoBehaviour {
	
//	public int playerHealth = 3;
	
	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
		
	}
	
	void OnTriggerEnter(Collider col){
		if(col.tag == "Enemy"){
			if(col.tag == "Enemy")
				Scoring.totalScore += 100;
			Destroy(col.gameObject);
			Destroy(gameObject);
		}
//		if(col.tag == "Player"){
//			playerHealth--;
//			if(playerHealth <= 0){
//				Destroy(col.gameObject);
//			}
//			Destroy(gameObject);
//		}
	}
}
