using UnityEngine;
using System.Collections;

public class DestroyEnemy : MonoBehaviour {
	
	public AudioClip sfx;
	
	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
		
	}
	
	void OnTriggerEnter(Collider col){
		if(col.tag == "Enemy"){
			Deactivate(col);
			
			Scoring.totalScore += EnemyDS.enemy1Points;
		}
		if(col.tag == "EnemyShooter"){
			Deactivate(col);
			
			Scoring.totalScore += EnemyDS.enemy2Points;
		}
		if(col.tag == "Bullets"){
			Deactivate(col);
		}
	}
	
	void Deactivate(Collider col){
		AudioSource.PlayClipAtPoint(sfx, Vector3.right);
		col.gameObject.SetActive(false);
		gameObject.SetActive(false);
	}
}
