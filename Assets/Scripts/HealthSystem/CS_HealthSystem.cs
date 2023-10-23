using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HealthSystem : MonoBehaviour
{
    public HealthBar healthBar;
    private int maxHealth;
    public int currentHealth;
    public Animator _animator;
    public GameObject chr;
    public bool clickable = true;
    public bool alive;
    public bool dead;
    
    private void Start()
    {
        maxHealth = PlayerData.healthPoint;
        currentHealth = maxHealth;
        healthBar.SetMaxHealth(maxHealth);
        dead = true;
        alive = false;
    }

    


    public void Damage()
    {        
        TakeDamage(20);
        if (PlayerData.healthPoint <= 0 && clickable)
        {
            clickable = false;
            PlayerData.healthPoint = 0;
            _animator.SetTrigger("TriggerDie");
            //dead = true;
        }            
        //Debug.Log("current = " + currentHealth + " data = " + PlayerData.healthPoint);
    }

















    public void Kill()
    {
        
            if(PlayerData.healthPoint > 0 && clickable)
        {
            clickable = false;
            TakeDamage(100);
            _animator.SetTrigger("TriggerDie");
            //dead = true;
            
            if (PlayerData.healthPoint < 0)
                PlayerData.healthPoint = 0;
        }           
       // Debug.Log(PlayerData.healthPoint + " left");
    }













    public void Revive()
    {
        if (_animator.gameObject.active == false)
            _animator.gameObject.active = true;
        if(PlayerData.healthPoint == 0 && !clickable)
        {
            clickable = true;
            Heal(100);
            _animator.SetTrigger("TriggerRevive");
            alive= true;
            

        }

        //Debug.Log("current = " + currentHealth + " data = " + PlayerData.healthPoint);
    }










    void TakeDamage(int damage)
    {        
        currentHealth -= damage;
        if (currentHealth < 0) currentHealth = 0;
        PlayerData.healthPoint = currentHealth;
        healthBar.SetHealth(PlayerData.healthPoint);
    }

    void Heal(int damage)
    {
        currentHealth += damage;
        if (currentHealth > 100) currentHealth = 100;
        PlayerData.healthPoint = currentHealth;
        healthBar.SetHealth(PlayerData.healthPoint);
    }
}
