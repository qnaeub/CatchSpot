using TMPro;
using UnityEngine;

public class SetUIText : MonoBehaviour
{
    [SerializeField]
    private TMP_Text textField;
    //[SerializeField]
    //private string fixedText;

    public void SetDestinationParkingZone(string zone)
    {
        textField.text = $"{zone}";
        Debug.Log("[Unity] 상단 Zone 설정 완료");
    }
}