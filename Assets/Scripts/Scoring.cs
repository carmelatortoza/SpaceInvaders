using UnityEngine;
using System.Collections;

public class Scoring : MonoBehaviour {
	
	public GUIText scoreText;
	
	public static int totalScore = 0;
	
	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
		scoreText.text = totalScore.ToString();
	}
	
	public static void Score(int score){
		totalScore += score;
	}
}
