using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CS_Visibility : MonoBehaviour
{

    public GameObject health;
    public GameObject spawner;
    // Start is called before the first frame update
   public void DisEvent()
    {
        //if (a == 0)
        this.gameObject.active = false;
        health.GetComponent<HealthSystem>().dead = true;
        spawner.GetComponent<Spawner>().deathCount++;
        Debug.Log("Total death = " + spawner.GetComponent<Spawner>().deathCount);
    }
}
