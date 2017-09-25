using UnityEngine;
using System.Collections;

public class TestNoise : MonoBehaviour
{
    public RenderTexture m_test = null;

    public float m_octaves = 4.0f;
    public float m_persistence = 0.5f;
    public float m_lacunarity = 2.0f;
    public int m_frequency = 7;
    public float m_amplitude = 0.6f;
    public Vector2 m_seed = Vector2.zero;

    Material m_material = null;
    void Awake()
    {
    }

    /// <summary>
    /// Start is called on the frame when a script is enabled just before
    /// any of the Update methods is called the first time.
    /// </summary>
    void Start()
    {
        Noise.CreatePerlinNoise2D(ref m_test, 512, 512, m_octaves, m_persistence, m_lacunarity, (float)m_frequency, m_amplitude, m_seed, Noise.NoiseType.Gradient);
    }
}
