using UnityEngine;
using System.Collections;

public class GameOver : MonoBehaviour {

	// Use this for initialization
	void Start () {
		CheckHighScore();
	}
	
	// Update is called once per frame
	void Update () {
	
	}
	
	void OnGUI(){
		GUI.Label(new Rect(180,120,100,40), "High Score: " + PlayerPrefs.GetInt("Highscore", 0).ToString());
		if(GUI.Button(new Rect(240, 160, 80, 20), "Play Again")){
			Application.LoadLevel("GameView");
			PlayerDS.Reset();
			EnemyDS.Reset();
		}
	}
	
	void CheckHighScore(){
		if(PlayerDS.Score() > PlayerPrefs.GetInt("Highscore", 0)){
			PlayerPrefs.SetInt("Highscore", PlayerDS.Score());
		}
	}
}
