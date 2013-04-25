using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class EnemySpawn : MonoBehaviour {
	
	public Rigidbody enemyModel;
	public Rigidbody enemyModel1;
	public int duration;
	public float respawnES = 3;
	public float respawnE = 2;
	public float minX = 40;
	public float maxX = 50;
	public float minY = -20;
	public float maxY = 20;	
	
	private float elapsedTime;
	
	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void FixedUpdate () {
		elapsedTime += Time.deltaTime;
		if(elapsedTime > respawnES){
			if(duration > 0){
				Rigidbody enemy = Instantiate (enemyModel, enemyModel.position, enemyModel.rotation) as Rigidbody;
				enemy.transform.Translate(Random.Range(minX, maxX), Random.Range(minY, maxY), 0);
//				elapsedTime = 0;
				duration--;
			}
		}
		if(elapsedTime > respawnE){
			if(duration > 0){
				Rigidbody enemy1 = Instantiate (enemyModel1, enemyModel1.position, enemyModel1.rotation) as Rigidbody;
				enemy1.transform.Translate(Random.Range(minX, maxX), Random.Range(minY, maxY), 0);
				elapsedTime = 0;
				duration--;
			}
		}
	}
}
