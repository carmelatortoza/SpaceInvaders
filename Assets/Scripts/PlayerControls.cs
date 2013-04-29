using UnityEngine;
using System.Collections;

public class PlayerControls : MonoBehaviour {
	
	public float moveSpeed = 10;
	public string target;
	public AudioClip sfx;
	public float valueForYRange = 10f;
	
	// Use this for initialization
	void Start () {
			
	}
	
	// Update is called once per frame
	void Update () {
		Move();
	}
	
	void Move (){
		if(Input.GetKey(KeyCode.UpArrow)){
			transform.Translate(Vector3.up * moveSpeed *Time.deltaTime);
		}
		if(Input.GetKey(KeyCode.DownArrow)){
			transform.Translate(Vector3.down * moveSpeed * Time.deltaTime);
		}
	}
		
	void OnTriggerEnter(Collider obj){
		PlayerHit(obj);
		if(PlayerDS.CurrentHealth() == 0){
//			Application.LoadLevel("GameOver");
			gameObject.SetActive(false);
		}
		Boundaries(obj);
	}
	
	void PlayerHit(Collider obj){
		if(obj.tag == target || obj.tag == "EnemyBullets"){
			AudioSource.PlayClipAtPoint(sfx, Vector3.right);
			
			PlayerDS.PlayerDamaged();
			obj.gameObject.SetActive(false);
		}
	}
	
	void Boundaries(Collider obj){
		if(obj.tag == "Boundaries"){
			if(obj.name == "Ceiling"){
				transform.position = new Vector3(transform.position.x, -valueForYRange, transform.position.z);
			}
			if(obj.name == "Floor"){
				transform.position = new Vector3(transform.position.x, valueForYRange, transform.position.z);
			}
		}
	}
}
