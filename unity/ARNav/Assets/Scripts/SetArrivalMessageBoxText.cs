using TMPro;
using UnityEngine;

public class SetArrivalMessageBoxText : MonoBehaviour
{
    [SerializeField]
    private TMP_Text textField;

    public void SetArrivalMessage(string zone)
    {
        textField.text = $"{zone}��\n�����߽��ϴ�.";
        Debug.Log("[Unity] Arrival Message ���� �Ϸ�");
    }
}
