using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class BulletSpawn : MonoBehaviour {
	
	public Rigidbody bulletPrefab;
	public Transform bulletEnd;
	public int firingSpeed;
	public float elapsedTime = 0.5f;
	public int numberOfBullets;
	
	private float duration = 0;
	private List<Rigidbody> bulletList;
	private int current = 0;
//	private Vector3 velo = new Vector3(10, 0, 0);
	
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
			FireAway(current);
			current++;
			duration = 0;
		}		
	}
	
	void FireAway(int i){
		if(current < numberOfBullets){
			bulletList[i].gameObject.SetActive(true);
			bulletList[i].transform.position = bulletEnd.position;
			bulletList[i].velocity = new Vector3(1,0,0);
			bulletList[i].AddForce(bulletEnd.right * firingSpeed);
//			bulletList[i].velocity.x = Mathf.Clamp(bulletList[i].velocity.x, -velo, velo);
//			current++;
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
