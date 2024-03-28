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
    public Camera TopDownCamera;

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
                    TopDownCamera.orthographicSize = 0.3f;
                    miniMapState = false;
                }
                else
                {
                    MiniMapFullScreen.SetActive(true);
                    TopDownCamera.orthographicSize = 0.6f;
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
        Debug.Log("[Unity] �ȳ��� �����մϴ�.");
        messageManager.SendMessageToFlutter("Finish");
    }
}