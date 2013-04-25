using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class EnemyBehavior : MonoBehaviour {
	
	public float moveSpeed=10;
	public float moveUp=2;
	public float moveDown=4;
	
	private float timePassed = 0;
	
	// Use this for initialization
	void Start () {
		
	}	
	
	// Update is called once per frame
	void FixedUpdate () {
		timePassed += Time.deltaTime;
		//Debug.Log(timePassed);
		Move ();
	}
	
	void MoveDown(){
		transform.Translate(Vector3.up * moveSpeed * Time.deltaTime);
	}
	
	void MoveUp(){
		transform.Translate(Vector3.down * moveSpeed * Time.deltaTime);
	}
	
	void MoveLeft(){
		transform.Translate(Vector3.left * moveSpeed * Time.deltaTime);
	}
	
	void Move(){
		if(timePassed > moveUp){
			MoveUp();
			MoveLeft();
		}else{
			MoveDown ();
			MoveLeft();
		}
		if(timePassed > moveDown){
			timePassed = 0;
		}
	}
	
	void OnTriggerEnter(Collider col){
		if(col.tag == "Boundaries"){
			Destroy(gameObject);
		}
	}
}
