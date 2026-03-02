using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TriggerQuad : MonoBehaviour
{
    public GameObject Quad;

    void OnTriggerEnter(Collider other)
    {
        Debug.Log("Something Entered");
        if (other.CompareTag("MainCamera"))
        {
              Quad.SetActive(true);
        }
    }

    void OnTriggerExit(Collider other)
    {
        if (other.CompareTag("MainCamera"))
        {
              Quad.SetActive(false);
        }
    }
}
