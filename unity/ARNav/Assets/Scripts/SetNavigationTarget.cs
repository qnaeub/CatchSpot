using FlutterUnityIntegration;
using System.Collections.Generic;
using System.Security.Policy;
using TMPro;
using UnityEngine;
using UnityEngine.AI;

public class SetNavigationTarget : MonoBehaviour
{
    [SerializeField]
    private TMP_Dropdown navigationTargetDropDown;
    [SerializeField]
    private List<Target> navigationTargetObjects = new List<Target>();

    private NavMeshPath path;   // current calculated path
    private LineRenderer line;  // linerenderer to display path
    private Vector3 targetPosition = Vector3.zero;  // current target position

    private bool lineToggle = true;

    public UnityMessageManager messageManager;

    private bool getFlutterValue = false;
    public GameObject parkingAreaPrefab;

    private void Awake()
    {
        messageManager = gameObject.AddComponent(typeof(UnityMessageManager)) as UnityMessageManager;
    }


    private void Start()
    {
        path = new NavMeshPath();
        line = transform.GetComponent<LineRenderer>();
        line.enabled = lineToggle;
        parkingAreaPrefab = Resources.Load("Prefabs/parkingAreaPrefab") as GameObject;
        messageManager.SendMessageToFlutter("SetNavigationTarget 실행");
    }

    private void Update()
    {
        if (lineToggle && targetPosition != Vector3.zero)
        {
            NavMesh.CalculatePath(transform.position, targetPosition, NavMesh.AllAreas, path);
            line.positionCount = path.corners.Length;
            line.SetPositions(path.corners);
        }
        if (getFlutterValue == true)
        {
            Debug.Log("[Unity] targetPosition: " + targetPosition);
            GameObject ob = Instantiate(parkingAreaPrefab);
            ob.transform.position = targetPosition;
            Debug.Log("[Unity] parkingAreaPrefab position: " + ob);
            getFlutterValue = false;
        }
    }

    public void SetCurrentNavigationTarget(int selectedValue)
    {
        Debug.Log("[Unity] 선택한 값: " + selectedValue);
        targetPosition = Vector3.zero;
        string selectedText = navigationTargetDropDown.options[selectedValue].text;
        Target currentTarget = navigationTargetObjects.Find(x => x.Name.Equals(selectedText));
        if (currentTarget != null)
        {
            Debug.Log("[Unity] 배정된 주차위치: " + selectedText);
            targetPosition = currentTarget.PositionObject.transform.position;
        }
    }

    public void SetCurrentNavigationTargetFlutter(string value)
    {
        Debug.Log("[Unity] 선택한 값: " + value);
        int selectedValue = int.Parse(value);
        targetPosition = Vector3.zero;
        string selectedText = navigationTargetDropDown.options[selectedValue].text;
        Target currentTarget = navigationTargetObjects.Find(x => x.Name.Equals(selectedText));
        if (currentTarget != null)
        {
            Debug.Log("[Unity] 배정된 주차위치: " + selectedText);
            targetPosition = currentTarget.PositionObject.transform.position;

            getFlutterValue = true;
        }
    }

    //public void ToggleVisibility()
    //{
    //    lineToggle = !lineToggle;
    //    line.enabled = lineToggle;
    //}
}
