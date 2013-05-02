using UnityEngine;

//[AddComponentMenu("NGUI/Examples/Load Level On Click Add Ons")]
public class PlayAgainButton : MonoBehaviour
{
	public string levelName;

	void OnClick ()
	{
		if (!string.IsNullOrEmpty(levelName))
		{
			Application.LoadLevel(levelName);
			PlayerDS.Reset();
			EnemyDS.Reset();
		}
	}
}