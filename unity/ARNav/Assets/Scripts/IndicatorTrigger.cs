using FlutterUnityIntegration;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Networking;

public class IndicatorTrigger : MonoBehaviour
{
    public bool state;
    public GameObject ArrivalMessageBox;

    public UnityMessageManager messageManager;

    private void Awake()
    {
        messageManager = gameObject.AddComponent(typeof(UnityMessageManager)) as UnityMessageManager;
    }

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
        messageManager.SendMessageToFlutter("Arrive");
        state = true;
    }
}
