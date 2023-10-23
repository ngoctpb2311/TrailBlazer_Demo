using JetBrains.Annotations;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.Rendering.Universal;

public class Spawner : MonoBehaviour
{
    public GameObject character;
    public GameObject health;
    
    public GameObject spawnVFX;
    public GameObject curseVFX;
    public Transform hitLoc;
    public GameObject deathVFX;

    
    public int summonCount = 0;
    public int deathCount = 0;


    
    




    public void Curse()
    {
        if(health.GetComponent<HealthSystem>().alive)
        {
            Instantiate(curseVFX, hitLoc.position, Quaternion.identity);
        }
    }





    public void SpawnUnit()
    {
        if (health.GetComponent<HealthSystem>().dead)
        {
            
            Instantiate(spawnVFX, transform.position, Quaternion.identity);
            health.GetComponent<HealthSystem>().alive = true;
            health.GetComponent<HealthSystem>().dead = false;
            summonCount++;
            Debug.Log("Total summoned = " + summonCount);
        }
    }

    public void DeSpawnUnity()
    {
        
    }
}