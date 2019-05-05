// Shader created with Shader Forge v1.38 
// Shader Forge (c) Freya Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:3,bdst:7,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:False,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:3138,x:32719,y:32712,varname:node_3138,prsc:2|normal-7842-OUT,alpha-8954-OUT;n:type:ShaderForge.SFN_Tex2d,id:4326,x:31758,y:32730,ptovrint:False,ptlb:tex,ptin:_tex,varname:node_4326,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:6c43b44f27033774b916a83cadcf9ea8,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Slider,id:7330,x:31704,y:33010,ptovrint:False,ptlb:Mask,ptin:_Mask,varname:node_7330,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.1,max:1;n:type:ShaderForge.SFN_Vector1,id:5828,x:31925,y:32595,varname:node_5828,prsc:2,v1:1;n:type:ShaderForge.SFN_Subtract,id:9942,x:32029,y:32708,varname:node_9942,prsc:2|A-5828-OUT,B-4326-R;n:type:ShaderForge.SFN_Subtract,id:7064,x:32095,y:32923,varname:node_7064,prsc:2|A-9942-OUT,B-7330-OUT;n:type:ShaderForge.SFN_Clamp01,id:1540,x:32205,y:32869,varname:node_1540,prsc:2|IN-7064-OUT;n:type:ShaderForge.SFN_Add,id:7936,x:32366,y:33048,varname:node_7936,prsc:2|A-1540-OUT,B-6627-OUT;n:type:ShaderForge.SFN_Multiply,id:6627,x:32177,y:33096,varname:node_6627,prsc:2|A-1540-OUT,B-7330-OUT;n:type:ShaderForge.SFN_Vector3,id:7842,x:32226,y:32577,varname:node_7842,prsc:2,v1:0,v2:0,v3:0;n:type:ShaderForge.SFN_Multiply,id:8954,x:32537,y:33223,varname:node_8954,prsc:2|A-7936-OUT,B-4326-A;proporder:4326-7330;pass:END;sub:END;*/

Shader "Shader Forge/ShadowOnly" {
	Properties{
		_tex("tex", 2D) = "white" {}
		_Mask("Mask", Range(0, 1)) = 0.1
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
				uniform sampler2D _tex; uniform float4 _tex_ST;
				uniform float _Mask;
				struct VertexInput {
					float4 vertex : POSITION;
					float3 normal : NORMAL;
					float4 tangent : TANGENT;
					float2 texcoord0 : TEXCOORD0;
				};
				struct VertexOutput {
					float4 pos : SV_POSITION;
					float2 uv0 : TEXCOORD0;
					float3 normalDir : TEXCOORD1;
					float3 tangentDir : TEXCOORD2;
					float3 bitangentDir : TEXCOORD3;
				};
				VertexOutput vert(VertexInput v) {
					VertexOutput o = (VertexOutput)0;
					o.uv0 = v.texcoord0;
					o.normalDir = UnityObjectToWorldNormal(v.normal);
					o.tangentDir = normalize(mul(unity_ObjectToWorld, float4(v.tangent.xyz, 0.0)).xyz);
					o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
					o.pos = UnityObjectToClipPos(v.vertex);
					return o;
				}
				float4 frag(VertexOutput i) : COLOR {
					i.normalDir = normalize(i.normalDir);
					float3x3 tangentTransform = float3x3(i.tangentDir, i.bitangentDir, i.normalDir);
					float3 normalLocal = float3(0,0,0);
					float3 normalDirection = normalize(mul(normalLocal, tangentTransform)); // Perturbed normals
	////// Lighting:
					float3 finalColor = 0;
					float4 _tex_var = tex2D(_tex,TRANSFORM_TEX(i.uv0, _tex));
					float node_1540 = saturate(((1.0 - _tex_var.r) - _Mask));
					return fixed4(finalColor,((node_1540 + (node_1540*_Mask))*_tex_var.a));
				}
				ENDCG
			}
		}
			FallBack "Diffuse"
					CustomEditor "ShaderForgeMaterialInspector"
}
