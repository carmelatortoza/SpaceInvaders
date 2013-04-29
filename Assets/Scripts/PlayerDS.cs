using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class PlayerDS : MonoBehaviour {
	
	public static int playerHealth = 3;
	public static int firingSpeed = 1000;
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
