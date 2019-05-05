using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MaterialChange : MonoBehaviour
{
    public bool meshAdd;
    public List<SkinnedMeshRenderer> skinnedMeshRenderers;
    public List<MeshRenderer> meshRenderers;
    public MaterialData[] materialData;
    public bool materialChange;
    public MaterialPreset materialPreset;
    private MaterialPreset tmp;

    private void OnValidate()
    {
        if (meshAdd)
        {
            skinnedMeshRenderers.Clear();
            meshRenderers.Clear();
            AddMesh(this.gameObject);
            meshAdd = false;
        }
        
        if (!materialChange) { return; }
        materialChange = false;

        if (materialPreset == tmp) return;
        if (materialPreset == MaterialPreset.ShadowOnly) {
            for (int i = 0; i < skinnedMeshRenderers.Count; i++)
            {
                skinnedMeshRenderers[i].shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.ShadowsOnly;
            }
            for (int i = 0; i < meshRenderers.Count; i++)
            {

                skinnedMeshRenderers[i].shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.ShadowsOnly;
            }
        }
        else if (tmp == MaterialPreset.ShadowOnly) {
            for (int i = 0; i < skinnedMeshRenderers.Count; i++)
            {
                skinnedMeshRenderers[i].shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.TwoSided;
            }
            for (int i = 0; i < meshRenderers.Count; i++)
            {

                skinnedMeshRenderers[i].shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.TwoSided;
            }
        }
        tmp=materialPreset;
        int select = (int)materialPreset;

        // Debug.Log("種類 " + materialPreset + "　選択番号　" + select);

        //子を含むレイヤー変更
        //Debug.Log(materialPreset.ToString());
        ChangeLayer(this.gameObject, materialPreset.ToString());


        for (int i = 0; i < skinnedMeshRenderers.Count; i++)
        {
            Material[] mats = skinnedMeshRenderers[i].materials;
            for (int m = 0; m < skinnedMeshRenderers[i].materials.Length; m++)
            {
                mats[m] = ChangeMat(skinnedMeshRenderers[i].materials[m], select);
            }
            skinnedMeshRenderers[i].materials = mats;
        }
        for (int i = 0; i < meshRenderers.Count; i++)
        {
            Material[] mats = meshRenderers[i].materials;
            for (int m = 0; m < meshRenderers[i].materials.Length; m++)
            {
                mats[m] = ChangeMat(meshRenderers[i].materials[m], select);
            }
            meshRenderers[i].materials = mats;
        }
    }

    private void AddMesh(GameObject self)
    {
        if (self.GetComponent<SkinnedMeshRenderer>())
        {
            SkinnedMeshRenderer skintmp = self.GetComponent<SkinnedMeshRenderer>();
            skinnedMeshRenderers.Add(skintmp);
            skintmp.shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.TwoSided;

        }else if (self.GetComponent<MeshRenderer>())
        {
            MeshRenderer meshtmp= self.GetComponent<MeshRenderer>();
            meshRenderers.Add(meshtmp);
            meshtmp.shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.TwoSided;

        }

        foreach (Transform transform in self.transform)
        {
            AddMesh(transform.gameObject);
        }
    }

    //再起で変更
    private void ChangeLayer(GameObject self,string layer)
    {
        self.layer = LayerMask.NameToLayer(layer);
        foreach (Transform transform in self.transform)
        {
            ChangeLayer(transform.gameObject, layer);
        }
    }

    private Material ChangeMat(Material mat,int select){
        
        // Debug.Log(mat.name);
        for (int f = 0; f < materialData.Length; f++)
        {

            foreach (MaterialObj materialObj in materialData[f].materialObjs)
            {
                bool check = false;
                for (int i = 0; i < materialObj.material.Length; i++)
                {

                    string nameTmp = (materialObj.materialName).Replace(" ", "");
                    // Debug.Log(nameTmp + " (instance)");
                    string matname = mat.name.Replace("(Instance)", "");
                    matname = matname.Replace(" ", "");
                    // Debug.Log(matname);
                    if (matname == nameTmp + i || matname == nameTmp)
                    {
                        check = true;
                        break;
                    }
                }
                if (check)
                {
                    if (materialObj.material[select] != null)
                    {
                        // Debug.Log(materialObj.material[select].name);
                        return materialObj.material[select];
                    }
                    else
                    {
                        Debug.Log("エラー" + materialObj.materialName);
                        return mat;
                    }
                }

            }
        }
        Debug.Log("エラー　該当なし");
        return mat;
    }

}
