using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class IndicatorTrigger : MonoBehaviour
{
    public bool state;
    public GameObject ArrivalMessageBox;

    void Start()
    {
        state = false;
    }

    void Update()
    {
        if (state == true)
         {
            ArrivalMessageBox.SetActive(true);
            GameObject.Find("ApplicationCanvas").GetComponent<ApplicationCanvasController>().SetMiniMapState();
            state = false;
         }
    }

    private void OnTriggerEnter(Collider other)
    {
        Debug.Log("[Unity] ���������� �����߽��ϴ�.");
        state = true;
    }
}
