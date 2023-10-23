using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraShake : MonoBehaviour
{
    public bool isShake;

    private void Update()
    {
        if(isShake == true)
        {
            StartCoroutine(Shake(0.6f, 1));            
        }
    }

    IEnumerator Shake(float duration, float magnitude)
    {
        Vector3 originalPos = transform.localPosition;
        Quaternion originalRot = transform.localRotation;

        float elapsed = 0.0f;

        while (elapsed < duration)
        {
            transform.localPosition = new Vector3(Random.Range(-15, 15), Random.Range(-15, 15), Random.Range(-15, 15)) * magnitude;
            transform.localRotation = Quaternion.Euler(new Vector3(Random.Range(-1, 1), Random.Range(-15, 15), Random.Range(-15, 15)) * magnitude);
            
            elapsed += Time.deltaTime;
            if(elapsed > duration)
            {
                isShake = false;
                BackToNormal();
            }

            yield return null;
        }
    }

    public void BackToNormal()
    {       
        transform.localPosition = Vector3.zero;
        transform.localRotation = Quaternion.identity;
    }
}
