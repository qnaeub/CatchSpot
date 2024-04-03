using FlutterUnityIntegration;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Networking;

public class IndicatorTrigger : MonoBehaviour
{
    public bool miniMapState;
    public bool arriveState;
    public GameObject ArrivalMessageBox;

    public UnityMessageManager messageManager;

    private void Awake()
    {
        messageManager = gameObject.AddComponent(typeof(UnityMessageManager)) as UnityMessageManager;
    }

    void Start()
    {
        miniMapState = false;
        arriveState = false;
    }

    void Update()
    {
        if (miniMapState == true)
         {
            ArrivalMessageBox.SetActive(true);
            GameObject.Find("ApplicationCanvas").GetComponent<ApplicationCanvasController>().SetMiniMapState();
            miniMapState = false;
         }
    }

    private void OnTriggerEnter(Collider other)
    {
        Debug.Log("[Unity] 주차구역에 도착했습니다.");
        if (arriveState == false)
        {
            messageManager.SendMessageToFlutter("Arrive");
            arriveState = true;
        }
        miniMapState = true;
    }
}
