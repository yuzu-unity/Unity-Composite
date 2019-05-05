//{"Values":["0","NTEC/Screen/Depth","_MainTex","0",""]}|{"position":{"serializedVersion":"2","x":0.0,"y":0.0,"width":212.0,"height":109.0},"name":"FloatSlider","selected":false,"Values":["FloatSlider_Name","Value","1","0","2"],"serial":0,"unique":-1,"type":"FloatSliderField"}|{"tempTextures":0,"passes":[{"position":{"serializedVersion":"2","x":0.0,"y":36.0,"width":212.0,"height":16.0},"InputLabels":["Game"],"OutputLabels":["Screen"],"PassLabels":["0"],"VariableLabels":["None"],"Input":0,"Output":0,"Pass":0,"Iterations":1,"Variable":0}],"passOptions":["0"],"inputOptions":["Game"],"outputOptions":["Screen"],"variableOptions":["None"]}
//\	CameraOutput\	1363.854\	212.2996\	192\	215\		False\			null\			null\		False\			null\			null\		False\			null\			null\		True\			4\			0\	DefaultUV\	563.854\	212.2996\	192\	175\		False\			null\			null\		False\			null\			null\		True\			2\			3\	CameraDepth\	970.4695\	217.2227\	192\	215\		True\			4\			1\		False\			null\			null\		False\			null\			null\		True\			1\			2\	_FloatSlider\	588.5714\	582.8571\	192\	95\		/FloatSlider_Name\		/1\		/-1\		True\			4\			2\	Mul\	1024.286\	592.8571\	192\	215\		/4\		True\			0\			3\		True\			2\			0\		True\			3\			0\		False\			null\			null

Shader "NTEC/Screen/Depth" {

	SubShader {
		Cull Off ZWrite Off ZTest Always

		Pass {
			HLSLPROGRAM
			#pragma vertex VertDefault
			#pragma fragment Frag

			//èCê≥
			#include "StdLib.hlsl"

			TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);
			TEXTURE2D_SAMPLER2D(_CameraDepthTexture, sampler_CameraDepthTexture);
			uniform half _FloatSlider_Name;

			half4 Frag (VaryingsDefault i) : SV_Target {
				half4 CameraOutput = 0.0;
				CameraOutput.rgb = (SAMPLE_TEXTURE2D(_CameraDepthTexture, sampler_CameraDepthTexture, i.texcoord).x * _FloatSlider_Name);
				return CameraOutput;
			}
			ENDHLSL
		}
	}
}