using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MiniMapFullScreenController : MonoBehaviour
{
    public bool state;
    public GameObject MiniMapFullScreen;
    public Camera TopDownCamera;

    void Start()
    {
        state = false;
    }

    void Update()
    {
        if (Input.GetMouseButtonDown(0))
        {
            if (state == true)
            {
                MiniMapFullScreen.SetActive(false);
                TopDownCamera.orthographicSize = 0.3f;
                state = false;
            } else
            {
                MiniMapFullScreen.SetActive(true);
                TopDownCamera.orthographicSize = 0.6f;
                state = true;
            }
        }
    }
}
