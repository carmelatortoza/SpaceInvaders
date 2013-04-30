using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class EnemySpawn : MonoBehaviour {
	
	public Rigidbody enemyModel;
	public int duration = 15;
	public int numberOfEnemies;
	public float respawnE = 2;
	public float minX = 40;
	public float maxX = 42;
	public float minY = -10;
	public float maxY = 10;	
	
	private float elapsedTime;
	private List<Rigidbody> enemy;
	private int current = 0;
	private int dur = 0;
	
	// Use this for initialization
	void Start () {
		enemy = new List<Rigidbody>();
		CreateEnemy(enemyModel, enemy);
		dur = duration;
	}
	
	// Update is called once per frame
	void FixedUpdate () {
		elapsedTime += Time.deltaTime;
		if(elapsedTime > respawnE){
			SpawnEnemy(current);
			current++;
			CheckEnemies(current - 1);
			elapsedTime = 0;
		}
//		CheckEnemies();
	}
	
	void SpawnEnemy(int i){
		if(duration > 0){
			if(i < numberOfEnemies && !enemy[i].gameObject.activeSelf){
				enemy[i].gameObject.SetActive(true);
				enemy[i].transform.position = new Vector3(Random.Range(minX, maxX), Random.Range(minY, maxY), 0);
			}
			duration--;
		}else{
			IncreaseDifficulty();
		}
	}
	
	void CreateEnemy(Rigidbody eModel, List<Rigidbody> list){
		for(int i = 0; i < numberOfEnemies; i++){
			Rigidbody en = Instantiate (eModel, eModel.position, eModel.rotation) as Rigidbody;
			en.gameObject.SetActive(false);
			list.Add(en);
		}
	}
	
	void CheckEnemies(int i){
		if(current >= numberOfEnemies){
			current = 0;
			for(int j = 0; j < numberOfEnemies; j++){
				if(!enemy[j].gameObject.activeSelf){
					enemy[j].transform.position = new Vector3(Random.Range(minX, maxX), Random.Range(minY, maxY), 0);
					enemy[j].gameObject.SetActive(false);
				}
			}
		}
	}
		
	void IncreaseDifficulty(){
		duration = dur;
		numberOfEnemies++;
		EnemyDS.firingSpeed += 1000;
		EnemyDS.moveSpeed ++;
		CreateEnemy(enemyModel, enemy);
	}
}
