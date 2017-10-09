using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;

/// <summary>
/// 生成噪声纹理
/// design by jiangchufei@gmail.com
/// date:2017-9-23
/// </summary> 

public class CreateNoise : ScriptableWizard
{
	public enum NoiseType
	{
		PerlinNoise,
		SimplexNoise,
		SeamlessNoise,
		SunDirction,
	}
	public NoiseType Type = NoiseType.SimplexNoise;
	public float Scale = 1;
	public int Offset = 1;
	public Vector3 SunDir = Vector3.one;

	[MenuItem("Tools/Create Noise")]
	static public void CreateNoiseTexture()
	{
		ScriptableWizard.DisplayWizard<CreateNoise>("create noise texture");
	}
	void OnWizardCreate()
	{
		float cell = 1.0f / 512f;
		Texture2D texture = new Texture2D(512, 512, TextureFormat.ARGB32, false);
		Vector4 noise = Vector4.one;
		for(int i = 0; i < 512; ++i)
		{
			for(int j = 0; j < 512; ++j)
			{
				float x = i * cell;
				float y = j * cell;

				if(Type == NoiseType.PerlinNoise)
				{
					x *= Scale;
					y *= Scale;
					noise *= NoiseUtils.Noise(NoiseEnum.Perlin, x, y, 0);
				}
				else if(Type == NoiseType.SimplexNoise)
				{
					x *= Scale;
					y *= Scale;
					noise *= NoiseUtils.Noise(NoiseEnum.Simplex, x, y, 0f);
				}
				else if(Type == NoiseType.SeamlessNoise)
				{
					noise *= NoiseUtils.SeamlessNoise(x, y, Scale, Scale, Offset);
				}
				else if(Type == NoiseType.SunDirction)
				{
					float a = Mathf.Sqrt(SunDir.x * SunDir.x + SunDir.y * SunDir.y);
					float b = Mathf.Sqrt(Vector3.Dot(SunDir, SunDir));
					float step = a / (3 * b);
					noise.x = NoiseUtils.SeamlessNoise(x, y, Scale, Scale, 0);
					noise.y = NoiseUtils.SeamlessNoise(x, y, Scale, Scale, step);
					noise.z = NoiseUtils.SeamlessNoise(x, y, Scale, Scale, step * 2);
					noise.w = NoiseUtils.SeamlessNoise(x, y, Scale, Scale, step * 3);
				}
				noise = (noise + Vector4.one) * 0.5f;
				texture.SetPixel(i, j, Color.white * noise);
			}
		}
		texture.Apply();

		byte[] bytes = texture.EncodeToPNG();
		string path = Application.dataPath + "/Explore/Noise/" + Type.ToString() + "_x" + Scale + "_" + Offset + ".png";
		File.WriteAllBytes(path, bytes);
		bytes = null;
		AssetDatabase.Refresh();
	}
}
