using UnityEngine;

public class WaterLineFollower : MonoBehaviour {
    public float waterLevel = 0f; 

    void Update() {
       
        Vector3 pos = transform.position;
        pos.y = waterLevel;
        transform.position = pos;
    }
}