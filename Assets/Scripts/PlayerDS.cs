using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class PlayerDS : MonoBehaviour {
	
	public static int playerHealth = 3;
	public static int firingSpeed = 1000;
	public static int totalScore = 0;
	
	public GUIText phText;
	public GUIText scoreText;
	
	// Use this for initialization
	void Start () {

	}
	
	// Update is called once per frame
	void Update () {
		DisplayHealth();
		DisplayScore();
	}
	
	void DisplayHealth(){
		phText.text = playerHealth.ToString();
	}
	
	public static void PlayerDamaged(){
		PlayerDS.playerHealth--;
	}
	
	public static int CurrentHealth(){
		return PlayerDS.playerHealth; 
	}
	
	public static void AddScore(int score){
		totalScore += score;
	}
	
	void DisplayScore(){
		scoreText.text = totalScore.ToString();
	}
	
	public static void Reset(){
		playerHealth = 3;
		firingSpeed = 1000;
		totalScore = 0;
	}
	
	public static int Score(){
		return totalScore;
	}
}
