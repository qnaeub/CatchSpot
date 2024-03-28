using TMPro;
using UnityEngine;

public class SetArrivalMessageBoxText : MonoBehaviour
{
    [SerializeField]
    private TMP_Text textField;

    public void SetArrivalMessage(string zone)
    {
        textField.text = $"{zone}에\n도착했습니다.";
        Debug.Log("[Unity] Arrival Message 설정 완료");
    }
}
