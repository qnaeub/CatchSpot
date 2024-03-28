using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ArrivalButtonController : MonoBehaviour
{
    public bool state;
    public GameObject ArrivalMessageBox;

    void Start()
    {
        state = true;
    }

    void Update()
    {
        if (state == false)
        {
            ArrivalMessageBox.SetActive(false);
            state = true;
        }
    }

    public void ArrivalCheck()
    {
        state = false;
    }
}
