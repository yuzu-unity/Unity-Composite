// Shader created with Shader Forge v1.38 
// Shader Forge (c) Freya Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:3,bdst:7,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:False,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:3138,x:32719,y:32730,varname:node_3138,prsc:2|emission-605-RGB,alpha-3487-OUT;n:type:ShaderForge.SFN_Tex2d,id:5786,x:32069,y:32987,ptovrint:False,ptlb:Mask,ptin:_Mask,varname:node_5786,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:1356eb55c0ed6204d93c046f463ca2d8,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Tex2d,id:605,x:32059,y:32772,ptovrint:False,ptlb:Shade,ptin:_Shade,varname:_node_5786_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:ed766437f6e08294b98dd9dd379a47e6,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Subtract,id:3487,x:32359,y:32938,varname:node_3487,prsc:2|A-605-A,B-5786-R;proporder:605-5786;pass:END;sub:END;*/

Shader "Shader Forge/Mask" {
    Properties {
        _Shade ("Shade", 2D) = "white" {}
        _Mask ("Mask", 2D) = "white" {}
		[HideInInspector]_Cutoff("Alpha cutoff", Range(0,1)) = 0.5
	}
		SubShader{
			Tags {
				"IgnoreProjector" = "True"
				"Queue" = "Transparent"
				"RenderType" = "Transparent"
			}
			Pass {
				Name "FORWARD"
				Tags {
					"LightMode" = "ForwardBase"
				}
				Blend SrcAlpha OneMinusSrcAlpha
				ZWrite Off

				CGPROGRAM
			//ïœçX
			#include "UnityCustomRenderTexture.cginc"
			#pragma vertex CustomRenderTextureVertexShader
            #pragma fragment frag
            
         
            uniform sampler2D _Mask; uniform float4 _Mask_ST;
            uniform sampler2D _Shade; uniform float4 _Shade_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.pos = UnityObjectToClipPos( v.vertex );
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
////// Lighting:
////// Emissive:
                float4 _Shade_var = tex2D(_Shade,TRANSFORM_TEX(i.uv0, _Shade));
                float3 emissive = _Shade_var.rgb;
                float3 finalColor = emissive;
                float4 _Mask_var = tex2D(_Mask,TRANSFORM_TEX(i.uv0, _Mask));
                return fixed4(finalColor,(_Shade_var.a-_Mask_var.r));
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
