using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class BulletSpawn : MonoBehaviour {
	
	public Rigidbody bulletPrefab;
	public Transform bulletEnd;
	public Transform playerPosition;
	public int firingSpeed = 1000;
	public float elapsedTime = 0.5f;
	public int numberOfBullets;
	
	private float duration = 0;
	private List<Rigidbody> bulletList;
	private int current = 0;
//	private Rigidbody[] bulletList = new Rigidbody[1];
	
	// Use this for initialization
	void Start () {
		bulletList = new List<Rigidbody>();
		for(int i=0; i < numberOfBullets; i++){
			Rigidbody bul = new Rigidbody();
			bulletList.Add(bul);
			bulletList[i] = (Rigidbody) Instantiate(bulletPrefab, bulletEnd.position, bulletEnd.rotation);
			bulletList[i].name = "bul";
			bulletList[i].gameObject.SetActive(false);
		}
	}
	
	// Update is called once per frame
	void Update () {
		duration += Time.deltaTime;
		
		if(Input.GetKeyDown(KeyCode.Space) && duration > elapsedTime){
			CheckBullets();
			FireAway(playerPosition,current);
			current++;
			duration = 0;
		}
		Debug.Log("current number"+current);
		
	}
	
	void FireAway(Transform pos, int i){
		if(current < numberOfBullets){
			bulletList[i].gameObject.SetActive(true);
			bulletList[i].AddForce(pos.right * firingSpeed);
//			current++;
		}
	}
	
	void CheckBullets(){
		if(current >= numberOfBullets){
			Debug.Log("current greater than "+current);
			Debug.Log("numberofbullets "+numberOfBullets);
			current = 0;
			for(int j = 0; j < numberOfBullets; j++){
				bulletList[j].transform.position = bulletEnd.position;
				bulletList[j].gameObject.SetActive(false);
			}
		}
	}
	
	void CreateBullets(){
		
	}
}
