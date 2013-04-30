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
			
			PlayerDS.AddScore(EnemyDS.enemy1Points);
		}
		if(col.tag == "EnemyShooter"){
			Deactivate(col);
			
			PlayerDS.AddScore(EnemyDS.enemy2Points);
		}
		if(col.tag == "EnemyBullets"){
			Deactivate(col);
		}
	}
	
	void Deactivate(Collider col){
		AudioSource.PlayClipAtPoint(sfx, Vector3.right);
		
		Instantiate(Resources.Load("Prefabs/Explosion"), col.transform.position, col.transform.rotation);
		Instantiate(Resources.Load("Prefabs/Explosion1"), col.transform.position, col.transform.rotation);
		
		col.gameObject.SetActive(false);
		gameObject.SetActive(false);
	}
}
