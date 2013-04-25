using UnityEngine;
using System.Collections;

public class PlayerControls : MonoBehaviour {
	
	public float moveSpeed = 10;
	public string target;
//	public int playerHealth = 3;
//	public GUIText phText;
	
	// Use this for initialization
	void Start () {
			
	}
	
	// Update is called once per frame
	void Update () {
		Move();
//		DisplayHealth();
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
		if(obj.tag == target){
//			playerHealth--;
			PlayerHealth.PlayerDamaged();
			Destroy(obj.gameObject);
		}
		if(PlayerHealth.CurrentHealth() == 0){
//			DisplayHealth();
			Destroy(gameObject);
//			Application.LoadLevel("GameOver");
		}
	}
	
//	void DisplayHealth(){
//		phText.text = playerHealth.ToString();
//	}
}
