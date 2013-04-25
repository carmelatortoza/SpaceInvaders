using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class PlayerDS : MonoBehaviour {
	
	public static int playerHealth = 3;
	public int numberOfBullets = 5;
	public int numberOfEnemies = 2;
	public static int firingSpeed = 1000;
	public Transform bulletEnd;
	public Rigidbody bulletPrefab;
	
	private List<Rigidbody> bulletList;
		
	// Use this for initialization
	void Start () {
//		bulletList = new List<Rigidbody>();
//		for(int i=0; i < numberOfBullets; i++){
//			Rigidbody bul = (Rigidbody) Instantiate(bulletPrefab, bulletEnd.position, bulletEnd.rotation);
//			bul.gameObject.SetActive(true);
//			bulletList.Add(bul);
//		}
	}
	
	// Update is called once per frame
	void Update () {
//		FireAway();
	}
	
	void CreateBullets(){
		
	}
	
	public void FireAway(){
//		foreach(Rigidbody bullet in bulletList){
//			bullet.gameObject.SetActive(true);
//			bullet.AddForce(bulletEnd.right * firingSpeed);
//		}
	}
	
	public void Deactivate(){
//		foreach(Rigidbody bullet in bulletList){
//			bullet.gameObject.SetActive(false);
//		}
	}
}
