using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class EnemyShootBehavior : MonoBehaviour {
	
	public Rigidbody bulletPrefab;
	public Transform bulletEnd;
	public int firingSpeed = 5000;
	public int numberOfBullets;
	public float duration = 1.5f;
	
	private int current = 0;
	private float timeElapsed;
	private List<Rigidbody> bulletList;
	
	// Use this for initialization
	void Start () {
		bulletList = new List<Rigidbody>();
		CreateBullets(bulletList);
	}
	
	// Update is called once per frame
	void Update () {
		timeElapsed += Time.deltaTime;
		if(timeElapsed > duration){
			CheckBullets();
			ShootAtPlayer(current);
			current++;
			timeElapsed = 0;
		}
	}
	
	void ShootAtPlayer(int i){
		if(current < numberOfBullets){
			bulletList[i].gameObject.SetActive(true);
			bulletList[i].AddForce(-bulletEnd.right * firingSpeed);
		}
	}
	
	void CreateBullets(List<Rigidbody> list){
		for(int i = 0; i < numberOfBullets; i++){
			Rigidbody bullet = Instantiate (bulletPrefab, bulletEnd.position, bulletEnd.rotation) as Rigidbody;
			bullet.name = "enBullets";
			bullet.gameObject.SetActive(false);
			list.Add(bullet);
		}
	}
	
	void CheckBullets(){
		if(current >= numberOfBullets){
			current = 0;
			for(int j = 0; j < numberOfBullets; j++){
				bulletList[j].transform.position = bulletEnd.position;
				bulletList[j].gameObject.SetActive(false);
			}
		}
	}
}
