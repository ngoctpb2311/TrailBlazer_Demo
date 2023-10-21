using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HealthSystem : MonoBehaviour
{
    public HealthBar healthBar;
    private int maxHealth;
    public int currentHealth;
    
    private void Start()
    {
        maxHealth = PlayerData.healthPoint;
        currentHealth = maxHealth;
        healthBar.SetMaxHealth(maxHealth);
    }    

    public void TakeDamage(int damage)
    {        
        currentHealth -= damage;
        healthBar.SetHealth(currentHealth);
    }
}
