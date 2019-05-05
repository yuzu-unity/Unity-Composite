using UnityEngine;
#if UNITY_EDITOR
using UnityEditor;
#endif
using System.Collections.Generic;

[System.Serializable]
public class MaterialObj
{
    public string materialName;
    [Header("ViewMaterial,normal, shade1st, shade2nd, shadeMask")]
    public Material[] material = new Material[4];
}

public enum MaterialPreset
{
    Normal,Base, Shade1st, ShadeMask,ShadowOnly
}

[CreateAssetMenu]
public class MaterialData : ScriptableObject
{
    public bool changeName;
    public MaterialObj[] materialObjs;

    private void OnValidate()
    {
        if (!changeName) { return; }
         changeName=false;
        foreach (MaterialObj materialObj in materialObjs) {
            materialObj.materialName = materialObj.material[0].name;

            for (int i = 1; i < materialObj.material.Length; i++)
            {
                if (materialObj.material[i] != null)
                {
                    materialObj.material[i].name = materialObj.material[0].name + " " + i;
                }
            }
        }
    }
}
