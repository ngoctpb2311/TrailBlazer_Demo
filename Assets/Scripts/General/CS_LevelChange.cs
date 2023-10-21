using UnityEngine;
using UnityEngine.SceneManagement;
using System.Collections;

public class LevelChanger : MonoBehaviour
{
    public Animator transition;
        
    public void LoadLevel(string level)
    {        
        StartCoroutine(Load(level));
    }

    IEnumerator Load(string levelName)
    {        
        //play animation
        transition.SetTrigger("FadeOut");

        //wait for time
        yield return new WaitForSeconds(0.9f);

        //load level        
        SceneManager.LoadScene("SCN_Game");        
    }
}