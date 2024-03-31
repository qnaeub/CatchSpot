using FlutterUnityIntegration;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ApplicationCanvasController : MonoBehaviour
{
    public bool miniMapState;
    public bool miniMapUsable;
    public bool arrivalState;
    public GameObject MiniMapFullScreen;
    public GameObject ArrivalMessageBox;
    //public Camera FullTopDownCamera;

    public UnityMessageManager messageManager;

    private void Awake()
    {
        messageManager = gameObject.AddComponent(typeof(UnityMessageManager)) as UnityMessageManager;
    }

    void Start()
    {
        miniMapState = false;
        miniMapUsable = true;
        arrivalState = true;
        messageManager.SendMessageToFlutter("Start");
    }

    void Update()
    {
        if (arrivalState == false)
        {
            ArrivalMessageBox.SetActive(false);
            arrivalState = true;
            miniMapUsable = true;
        }

        if (miniMapUsable == true)
        {
            if (Input.GetMouseButtonDown(0))
            {
                if (miniMapState == true)
                {
                    MiniMapFullScreen.SetActive(false);
                    miniMapState = false;
                }
                else
                {
                    MiniMapFullScreen.SetActive(true);
                    miniMapState = true;
                }
            }
        }
    }

    public void SetMiniMapState()
    {
        miniMapUsable = false;
    }

    public void ArrivalCheck()
    {
        arrivalState = false;
    }

    public void ArrivalFinish()
    {
        Debug.Log("[Unity] 안내를 종료합니다.");
        messageManager.SendMessageToFlutter("Finish");
    }
}
