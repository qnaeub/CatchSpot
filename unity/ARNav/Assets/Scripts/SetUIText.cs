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
        Debug.Log("[Unity] ��� Zone ���� �Ϸ�");
    }
}