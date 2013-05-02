using UnityEngine;
using System.Collections;

public class GameOver : MonoBehaviour {
	
	public Transform scoreLabel;
	
	// Use this for initialization
	void Start () {
		CheckHighScore();
		UILabel lab = transform.GetComponent<UILabel>() as UILabel;
		lab.text = "High Score: " + PlayerPrefs.GetInt("Highscore", 0).ToString();
		UILabel lab1 = scoreLabel.transform.GetComponent<UILabel>() as UILabel;
		lab1.text = "Score: " + PlayerDS.Score();
	}
	
	// Update is called once per frame
	void Update () {
	
	}
	
	void CheckHighScore(){
		if(PlayerDS.Score() > PlayerPrefs.GetInt("Highscore", 0)){
			PlayerPrefs.SetInt("Highscore", PlayerDS.Score());
		}
	}
}
