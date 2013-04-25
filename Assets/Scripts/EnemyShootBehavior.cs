using UnityEngine;
using System.Collections;

public class EnemyShootBehavior : MonoBehaviour {
	
	public Rigidbody bulletPrefab;
	public Transform bulletEnd;
	public int firingSpeed = 5000;
	public float duration = 1.5f;
	
	private float timeElapsed;
	
	
	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
		timeElapsed += Time.deltaTime;
		if(timeElapsed > duration){
			ShootAtPlayer();
			timeElapsed = 0;
		}
	}
	
	void ShootAtPlayer(){
		Rigidbody bullet;
		bullet = Instantiate(bulletPrefab, bulletEnd.position, bulletEnd.rotation) as Rigidbody;
		bullet.name = "enBullets";
		bullet.AddForce(-bulletEnd.right * firingSpeed);
	}
}
