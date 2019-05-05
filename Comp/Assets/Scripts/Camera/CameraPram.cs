using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraPram : MonoBehaviour
{
    public Camera[] cameras;

    // Start is called before the first frame update
    void Start()
    {
        for(int i=1; i<cameras.Length; i++)
        {
            cameras[i].fieldOfView = cameras[0].fieldOfView;
        }
    }

    // Update is called once per frame
    void Update()
    {
   // cameras.    
    }
}
