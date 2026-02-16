using UnityEngine;
using UnityEngine.Rendering;

public class UnderwaterController : MonoBehaviour
{
    public Volume underwaterVolume;

    void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("MainCamera"))
        {
            RenderSettings.fog = true; // เปิดหมอก
            underwaterVolume.weight = 1f; // เปิด Effect (สีฟ้า, เบี้ยว)
        }
    }

    void OnTriggerExit(Collider other)
    {
        if (other.CompareTag("MainCamera"))
        {
            RenderSettings.fog = false; // ปิดหมอก
            underwaterVolume.weight = 0f; // ปิด Effect
        }
    }
}