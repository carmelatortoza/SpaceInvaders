using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class EnemyBehavior : MonoBehaviour {
	
	public float moveUp=2;
	public float moveDown=4;
	
	private float timePassed = 0;
	
	// Use this for initialization
	void Start () {
		
	}	
	
	// Update is called once per frame
	void FixedUpdate () {
		timePassed += Time.deltaTime;
		Move ();
	}
	
	void MoveDown(){
		transform.Translate(Vector3.up * EnemyDS.moveSpeed * Time.deltaTime);
	}
	
	void MoveUp(){
		transform.Translate(Vector3.down * EnemyDS.moveSpeed * Time.deltaTime);
	}
	
	void MoveLeft(){
		transform.Translate(Vector3.left * EnemyDS.moveSpeed * Time.deltaTime);
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
			if(col.name == "Ceiling"){
				transform.position = new Vector3(transform.position.x, -10f, transform.position.z);
			}
			if(col.name == "Floor"){
				transform.position = new Vector3(transform.position.x, 10f, transform.position.z);
			}
			if(col.name == "Left"){
				gameObject.SetActive(false);
			}
		}
	}
}
