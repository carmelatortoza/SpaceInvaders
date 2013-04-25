using UnityEngine;
using System.Collections;

public class PlayerHealth : MonoBehaviour {
	
	public GUIText phText;

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
		DisplayHealth();
	}
	
	void DisplayHealth(){
		phText.text = PlayerDS.playerHealth.ToString();
	}
	
	public static void PlayerDamaged(){
		PlayerDS.playerHealth--;
	}
	
	public static int CurrentHealth(){
		return PlayerDS.playerHealth; 
	}
}
