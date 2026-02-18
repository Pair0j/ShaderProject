using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UnderwaterEffect : MonoBehaviour
{
    public Color waterColor = new Color(0, 0.4f, 0.7f, 0.6f);

    void OnTriggerEnter(Collider other) {

        if(other.CompareTag("MainCamera")){
        
            RenderSettings.fog = true; 
            RenderSettings.fogColor = waterColor;
            RenderSettings.fogDensity = 0.4f;
            Debug.Log("You are in");
        }
    }

    void OnTriggerExit(Collider other) {
        if (other.CompareTag("MainCamera")) {
            RenderSettings.fog = false;
            Debug.Log("You are out");
        }
    }
}