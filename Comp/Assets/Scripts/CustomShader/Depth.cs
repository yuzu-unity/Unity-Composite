using System;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

namespace NTEC.PPU
{
	[Serializable]
	[PostProcess(typeof(DepthRenderer), PostProcessEvent.AfterStack, "NTEC/Screen/Depth")]
	public sealed class Depth : PostProcessEffectSettings
	{
		[Range(0f, 2f), Tooltip("Value")]
		public FloatParameter FloatSlider_Name = new FloatParameter {value = 1f};
	}

	public sealed class DepthRenderer : PostProcessEffectRenderer<Depth>
	{
		public override void Render(PostProcessRenderContext context)
		{
			var sheet = context.propertySheets.Get(Shader.Find("NTEC/Screen/Depth"));
			sheet.properties.SetFloat("_FloatSlider_Name", settings.FloatSlider_Name);
			context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0);
		}
	}
}