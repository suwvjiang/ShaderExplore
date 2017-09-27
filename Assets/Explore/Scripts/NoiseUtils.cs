using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public delegate float FadeFunction(float t);
public delegate float NoiseFunction(float x);
public delegate float Noise2DFunction(float x, float y);
public delegate float Noise3DFunction(float x, float y, float z);
public delegate float Noise4DFunction(float x, float y, float z, float w);

public enum NoiseEnum
{
	Perlin,
	Value,
	Simplex,
}

/// <summary>
/// 噪声集合类
/// design by jiangchufei@gmail.com
/// date:2017-9-27
/// </summary> 

public class NoiseUtils
{
	static private readonly int[] permutation = 
	{ 
		151,160,137, 91, 90, 15,131, 13,201, 95, 96, 53,194,233,  7,225,// Hash lookup table as defined by Ken Perlin.  This is a randomly
		140, 36,103, 30, 69,142,  8, 99, 37,240, 21, 10, 23,190,  6,148,// arranged array of all numbers from 0-255 inclusive.
		247,120,234, 75,  0, 26,197, 62, 94,252,219,203,117, 35, 11, 32,
		 57,177, 33,  8,237,149, 56, 87,174, 20,125,136,171,168, 68,175,
		 74,165, 71,134,139, 48, 27,166, 77,146,158,231, 83,111,229,122,
		 60,211,133,230,220,105, 92, 41, 55, 46,245, 40,244,102,143, 54,
		 65, 25, 63,161,  1,216, 80, 73,209, 76,132,187,208, 89, 18,169,
		200,196,135,130,116,188,159, 86,164,100,109,198,173,186,  3, 64,
		 52,217,226,250,124,123,  5,202, 38,147,118,126,255, 82, 85,212,
		207,206, 59,227, 47, 16, 58, 17,182,189, 28, 42,223,183,170,213,
		119,248,152,  2, 44,154,163, 70,221,153,101,155,167, 43,172,  9,
		129, 22, 39,253, 19, 98,108,110, 79,113,224,232,178,185,112,104,
		218,246, 97,228,251, 34,242,193,238,210,144, 12,191,179,162,241,
		 81, 51,145,235,249, 14,239,107, 49,192,214, 31,181,199,106,157,
		184, 84,204,176,115,121, 50, 45,127,  4,150,254,138,236,205, 93,
		222,114, 67, 29, 24, 72,243,141,128,195, 78, 66,215, 61,156,180
	};

	static private int[] p = new int[512];

    static private int[][] grad3 = new int[][]{
						new int[]{1, 1, 0},
						new int[]{-1, 1, 0},
                        new int[]{1, -1, 0},
						new int[]{-1, -1, 0},
						new int[]{1, 0, 1},
						new int[]{-1, 0, 1},
                        new int[]{1, 0, -1},
						new int[]{-1, 0, -1},
						new int[]{0, 1, 1},
						new int[]{0, -1, 1},
                        new int[]{0, 1, -1},
						new int[]{0, -1, -1} };
 
    static private int[][] grad4 = new int[][]{
						new int[]{ 0, 1, 1, 1 },
						new int[]{ 0, 1, 1, -1 },
                        new int[]{ 0, 1, -1, 1 },
						new int[]{ 0, 1, -1, -1 },
						new int[]{ 0, -1, 1, 1 },
                        new int[]{ 0, -1, 1, -1 },
						new int[]{ 0, -1, -1, 1 },
						new int[]{ 0, -1, -1, -1 },
                        new int[]{ 1, 0, 1, 1 },
						new int[]{ 1, 0, 1, -1 },
						new int[]{ 1, 0, -1, 1 },
						new int[]{ 1, 0, -1, -1 },
                        new int[]{ -1, 0, 1, 1 },
						new int[]{ -1, 0, 1, -1 },
						new int[]{ -1, 0, -1, 1 },
                        new int[]{ -1, 0, -1, -1 },
						new int[]{ 1, 1, 0, 1 },
						new int[]{ 1, 1, 0, -1 },
                        new int[]{ 1, -1, 0, 1 },
						new int[]{ 1, -1, 0, -1 },
						new int[]{ -1, 1, 0, 1 },
                        new int[]{ -1, 1, 0, -1 },
						new int[]{ -1, -1, 0, 1 },
						new int[]{ -1, -1, 0, -1 },
                        new int[]{ 1, 1, 1, 0 },
						new int[]{ 1, 1, -1, 0 },
						new int[]{ 1, -1, 1, 0 },
						new int[]{ 1, -1, -1, 0 },
                        new int[]{ -1, 1, 1, 0 },
						new int[]{ -1, 1, -1, 0 },
						new int[]{ -1, -1, 1, 0 },
                        new int[]{ -1, -1, -1, 0 } };
 
    // A lookup table to traverse the simplex around a given point in 4D.
    // Details can be found where this table is used, in the 4D Noise method.
    static private int[][] simplex = new int[][]{
        new int[]{0,1,2,3}, new int[]{0,1,3,2}, new int[]{0,0,0,0}, new int[]{0,2,3,1}, new int[]{0,0,0,0}, new int[]{0,0,0,0}, new int[]{0,0,0,0}, new int[]{1,2,3,0},
        new int[]{0,2,1,3}, new int[]{0,0,0,0}, new int[]{0,3,1,2}, new int[]{0,3,2,1}, new int[]{0,0,0,0}, new int[]{0,0,0,0}, new int[]{0,0,0,0}, new int[]{1,3,2,0},
        new int[]{0,0,0,0}, new int[]{0,0,0,0}, new int[]{0,0,0,0}, new int[]{0,0,0,0}, new int[]{0,0,0,0}, new int[]{0,0,0,0}, new int[]{0,0,0,0}, new int[]{0,0,0,0},
        new int[]{1,2,0,3}, new int[]{0,0,0,0}, new int[]{1,3,0,2}, new int[]{0,0,0,0}, new int[]{0,0,0,0}, new int[]{0,0,0,0}, new int[]{2,3,0,1}, new int[]{2,3,1,0},
        new int[]{1,0,2,3}, new int[]{1,0,3,2}, new int[]{0,0,0,0}, new int[]{0,0,0,0}, new int[]{0,0,0,0}, new int[]{2,0,3,1}, new int[]{0,0,0,0}, new int[]{2,1,3,0},
        new int[]{0,0,0,0}, new int[]{0,0,0,0}, new int[]{0,0,0,0}, new int[]{0,0,0,0}, new int[]{0,0,0,0}, new int[]{0,0,0,0}, new int[]{0,0,0,0}, new int[]{0,0,0,0},
        new int[]{2,0,1,3}, new int[]{0,0,0,0}, new int[]{0,0,0,0}, new int[]{0,0,0,0}, new int[]{3,0,1,2}, new int[]{3,0,2,1}, new int[]{0,0,0,0}, new int[]{3,1,2,0},
        new int[]{2,1,0,3}, new int[]{0,0,0,0}, new int[]{0,0,0,0}, new int[]{0,0,0,0}, new int[]{3,1,0,2}, new int[]{0,0,0,0}, new int[]{3,2,0,1}, new int[]{3,2,1,0}};

	//Fn = (sqrt(n+1)-1)/n
	//Gn = (n+1 - sqrt(n+1))/(n * (n+1))
	private const float F2 = 0.366025404f;
    private const float G2 = 0.211324865f;
	private const float F3 = 0.333333333f;
	private const float G3 = 0.166666667f;
	private const float F4 = 0.309017f;
	private const float G4 = 0.1381966f;

	static NoiseUtils()
	{
		for( int i = 0; i < 512; i++ )
            p[i] = permutation[i & 255];
	}

	static private int fastfloor( float x )
    {
        return x > 0 ? ( int )x : ( int )x - 1;
    }
	static private float lerp(float a, float b, float t)
	{
		return a * (1-t) + b * t;
	}

    static private float dot( int[] g, float x, float y )
    {
        return g[0] * x + g[1] * y;
    }

    static private float dot( int[] g, float x, float y, float z )
    {
        return g[0] * x + g[1] * y + g[2] * z;
    }

    static private float dot( int[] g, float x, float y, float z, float w )
    {
        return g[0] * x + g[1] * y + g[2] * z + g[3] * w;
    }

	static private int PerlinHash(int x, int y)
	{
		return p[p[x]+y];
	}

	static private int PerlinHash(int x, int y, int z)
	{
		return p[p[p[x]+y]+z];
	}

	static private float RandomHash(int x)
	{
		int n = (x<<13)^x;
		return (1 - ((n * (n * n * 15731 + 789221) + 1376312589) & 0x7fffffff) / 1073741824.0f);
	}

	static private float RandomHash(int x, int y)
	{
		int n = x + y * 57;
		return RandomHash(n);
	}

	static private float RandomHash(int x, int y, int z)
	{
		int n = x + y * 57 + z * 131;
		return RandomHash(n);
	}

	//暂无执行函数
	static private float PerlinGradient(int hash, float x, float y)
	{
		return 0;
	}

	static private float PerlinGradient(int hash, float x, float y, float z)
	{
		int h = hash & 15;									// Take the hashed value and take the first 4 bits of it (15 == 0b1111)
		float u = h < 8 /* 0b1000 */ ? x : y;				// If the most significant bit (MSB) of the hash is 0 then set u = x.  Otherwise y.
		
		float v;											// In Ken Perlin's original implementation this was another conditional operator (?:).  I
															// expanded it for readability.
		
		if(h < 4 /* 0b0100 */)								// If the first and second significant bits are 0 set v = y
			v = y;
		else if(h == 12 /* 0b1100 */ || h == 14 /* 0b1110*/)// If the first and second significant bits are 1 set v = x
			v = x;
		else 												// If the first and second significant bits are not equal (0/1, 1/0) set v = z
			v = z;
		
		return ((h&1) == 0 ? u : -u)+((h&2) == 0 ? v : -v); // Use the last 2 bits to decide if u and v are positive or negative.  Then return their addition.
	}

	//
	static private float CosFade(float t)
	{
		return (1 - Mathf.Cos(t * Mathf.PI)) * 0.5f;
	}

	//
	static private float ThirdFade(float t)
	{
		return t * t * (-2 * t + 3);
	}

	//
	static private float FifthFade(float t)
	{
		return t * t * t * (t * (t * 6.0f - 15.0f) + 10.0f);
	}

	//暂无执行函数
	static private float PerlinNoise(float x, float y)
	{
		return Mathf.PerlinNoise(x, y);
	}

	static private float PerlinNoise(float x, float y, float z)
	{
		int ix = Mathf.FloorToInt(x);
		int iy = Mathf.FloorToInt(y);
		int iz = Mathf.FloorToInt(z);
		float fx = x - ix;
		float fy = y - iy;
		float fz = z - iz;

		int hash000 = PerlinHash(ix, iy, iz);
		int hash100 = PerlinHash(ix+1, iy, iz);
		int hash010 = PerlinHash(ix, iy+1, iz);
		int hash110 = PerlinHash(ix+1, iy+1, iz);
		int hash001 = PerlinHash(ix, iy, iz+1);
		int hash101 = PerlinHash(ix+1, iy, iz+1);
		int hash011 = PerlinHash(ix, iy+1, iz+1);
		int hash111 = PerlinHash(ix+1, iy+1, iz+1);

		float u = FifthFade(fx);
		float v = FifthFade(fy);
		float w = FifthFade(fz);

		float g000 = PerlinGradient(hash000, fx, fy, fz);
		float g100 = PerlinGradient(hash100, fx-1, fy, fz);
		float lerp0 = lerp(g000, g100, u);

		float g010 = PerlinGradient(hash010, fx, fy-1, fz);
		float g110 = PerlinGradient(hash110, fx-1, fy-1, fz);
		float lerp1 = lerp(g010, g110, u);

		float g001 = PerlinGradient(hash001, fx, fy, fz-1);
		float g101 = PerlinGradient(hash101, fx-1, fy, fz-1);
		float lerp2 = lerp(g001, g101, u);

		float g011 = PerlinGradient(hash011, fx, fy-1, fz-1);
		float g111 = PerlinGradient(hash111, fx-1, fy-1, fz-1);
		float lerp3 = lerp(g011, g111, u);

		float lerp4 = lerp(lerp0, lerp1, v);
		float lerp5 = lerp(lerp2, lerp3, v);

		return (lerp(lerp4, lerp5, w) + 1) * 0.5f;
	}

	static private int SimplexHash(int x, int y)
	{
		return p[x + p[y]] % 12;
	}

	static private int SimplexHash(int x, int y, int z)
	{
		return p[x + p[y + p[z]]] % 12;
	}

	static private int SimplexHash(int x, int y, int z, int w)
	{
		return p[x + p[y + p[z + p[w]]]] % 32;
	}

	static private float SimplexGradient(int hash, float x, float y)
	{
		float t = 0.5f - (x * x + y * y);
		if(t < 0)
			return 0;
		t *= t;
		return t * t * dot(grad3[hash], x, y);
	}

	static private float SimplexGradient(int hash, float x, float y, float z)
	{
		float t = 0.6f - (x * x + y * y + z * z);
		if(t < 0)
			return 0;
		t *= t;
		return t * t * dot(grad3[hash], x, y, z);
	}

	static private float SimplexGradient(int hash, float x, float y, float z, float w)
	{
		float t = 0.6f - (x * x + y * y + z * z + w * w);
		if(t < 0)
			return 0;
		t *= t;
		return t * t * dot(grad4[hash], x, y, z, w);
	}

	static private float SimplexNoise(float x, float y)
	{
		//after transform's origin point
		float xt = x + (x + y) * F2;
		float yt = y + (x + y) * F2;
		int ixt = fastfloor(xt);
		int iyt = fastfloor(yt);

		//before tranform's origin point;
		float x0 = ixt - (ixt + iyt) * G2;
		float y0 = iyt - (ixt + iyt) * G2;
		//origin distance
		float fx = x - x0;
		float fy = y - y0;

		int i, j;
		if(fx > fy)
		{
			i = 1;
			j = 0;
		}
		else
		{
			i = 0;
			j = 1;
		}
		//middle corner (1, 0) or (0, 1)
		//float x1 = i - (i + j) * G2 = i - G2
		//float y1 = j - (i + j) * G2 = j - G2
		float fx1 = fx - i + G2;//fx - x1
		float fy1 = fy - j + G2;//fy - y1

		//last corner(1, 1)
		//float x2 = 1 - 2 * G2;
		//float y2 = 1 - 2 * G2;
		float fx2 = fx - 1 + 2 * G2;//fx - x2;
		float fy2 = fy - 1 + 2 * G2;//fy - y2;

		// Calculate the contribution from the three corners
		ixt &= 255;
		iyt &= 255;
		float n = SimplexGradient(SimplexHash(ixt, iyt), fx, fy);
		float n1 = SimplexGradient(SimplexHash(ixt+i, iyt+j), fx1, fy1);
		float n2 = SimplexGradient(SimplexHash(ixt+1, iyt+1), fx2, fy2);

		float noise = 70f * (n+n1+n2);//[-1, 1]
		return (noise + 1) * 0.5f;
	}

	static private float SimplexNoise(float x, float y, float z)
	{
		float f = (x + y + z) * F3;
		int ixt = fastfloor(x + f);
		int iyt = fastfloor(y + f);
		int izt = fastfloor(z + f);

		float g = (ixt + iyt + izt) * G3;
		float x0 = ixt - g;
		float y0 = iyt - g;
		float z0 = izt - g;

		float fx0 = x - x0;
		float fy0 = y - y0;
		float fz0 = z - z0;

		int i1, j1, k1;
		int i2, j2, k2;
		if(fx0 >= fy0)
		{
			if(fy0 >= fz0)//xyz
			{
				i1 = 1;
				j1 = 0;
				k1 = 0;
				i2 = 1;
				j2 = 1;
				k2 = 0;
			}
			else if(fx0 >= fz0)//xzy
			{
				i1 = 1;
				j1 = 0;
				k1 = 0;
				i2 = 1;
				j2 = 0;
				k2 = 1;
			}
			else//zxy
			{
				i1 = 0;
				j1 = 0;
				k1 = 1;
				i2 = 1;
				j2 = 0;
				k2 = 1;
			}
		}
		else
		{
			if(fy0 < fz0)//zyx
			{
				i1 = 0;
				j1 = 0;
				k1 = 1;
				i2 = 0;
				j2 = 1;
				k2 = 1;
			}
			else if(fx0 < fz0)//yxz
			{
				i1 = 0;
				j1 = 1;
				k1 = 0;
				i2 = 0;
				j2 = 1;
				k2 = 1;
			}
			else//yzx
			{
				i1 = 0;
				j1 = 1;
				k1 = 0;
				i2 = 1;
				j2 = 1;
				k2 = 0;
			}
		}

		float fx1 = fx0 - i1 + G3;
		float fy1 = fy0 - j1 + G3;
		float fz1 = fz0 - k1 + G3;

		float fx2 = fx0 - i2 + 2 * G3;
		float fy2 = fy0 - j2 + 2 * G3;
		float fz2 = fz0 - k2 + 2 * G3;

		float fx3 = fx0 - 1 + 3 * G3;
		float fy3 = fy0 - 1 + 3 * G3;
		float fz3 = fz0 - 1 + 3 * G3;

		ixt &= 255;
		iyt &= 255;
		izt &= 255;
		float n = SimplexGradient(SimplexHash(ixt, iyt, izt), fx0, fy0, fz0);
		float n1 = SimplexGradient(SimplexHash(ixt+i1, iyt+j1, izt+k1), fx1, fy1, fz1);
		float n2 = SimplexGradient(SimplexHash(ixt+i2, iyt+j2, izt+k2), fx2, fy2, fz2);
		float n3 = SimplexGradient(SimplexHash(ixt+1, iyt+1, izt+1), fx3, fy3, fz3);

		float noise = 32f * (n + n1 + n2 + n3);//[-1, 1]
		return (noise + 1) * 0.5f;
	}

	static private float SimplexNoise(float x, float y, float z, float w)
	{
		float f = (x+y+z+w)*F4;
		int ix0 = fastfloor(x + f);
		int iy0 = fastfloor(y + f);
		int iz0 = fastfloor(z + f);
		int iw0 = fastfloor(w + f);

		float g = (ix0 + iy0 + iz0 + iw0) * G4;
		float x0 = ix0 - g;
		float y0 = iy0 - g;
		float z0 = iz0 - g;
		float w0 = iw0 - g;

		float fx0 = x - x0;
		float fy0 = y - y0;
		float fz0 = z - z0;
		float fw0 = w - w0;

		int c1 = ( fx0 > fy0 ) ? 32 : 0;
        int c2 = ( fx0 > fz0 ) ? 16 : 0;
        int c3 = ( fy0 > fz0 ) ? 8 : 0;
        int c4 = ( fx0 > fw0 ) ? 4 : 0;
        int c5 = ( fy0 > fw0 ) ? 2 : 0;
        int c6 = ( fz0 > fw0 ) ? 1 : 0;
        int c = c1 + c2 + c3 + c4 + c5 + c6;
        int i1, j1, k1, l1; // The integer offsets for the second simplex corner
        int i2, j2, k2, l2; // The integer offsets for the third simplex corner
        int i3, j3, k3, l3; // The integer offsets for the fourth simplex corner
        // simplex[c] is a 4-vector with the numbers 0, 1, 2 and 3 in some order.
        // Many values of c will never occur, since e.g. x>y>z>w makes x<z, y<w and x<w
        // impossible. Only the 24 indices which have non-zero entries make any sense.
        // We use a thresholding to set the coordinates in turn from the largest magnitude.
        // The number 3 in the "simplex" array is at the position of the largest coordinate.
        i1 = simplex[c][0] >= 3 ? 1 : 0;
        j1 = simplex[c][1] >= 3 ? 1 : 0;
        k1 = simplex[c][2] >= 3 ? 1 : 0;
        l1 = simplex[c][3] >= 3 ? 1 : 0;
        // The number 2 in the "simplex" array is at the second largest coordinate.
        i2 = simplex[c][0] >= 2 ? 1 : 0;
        j2 = simplex[c][1] >= 2 ? 1 : 0;
        k2 = simplex[c][2] >= 2 ? 1 : 0;
        l2 = simplex[c][3] >= 2 ? 1 : 0;
        // The number 1 in the "simplex" array is at the second smallest coordinate.
        i3 = simplex[c][0] >= 1 ? 1 : 0;
        j3 = simplex[c][1] >= 1 ? 1 : 0;
        k3 = simplex[c][2] >= 1 ? 1 : 0;
        l3 = simplex[c][3] >= 1 ? 1 : 0;

		float fx1 = fx0 - i1 + G4; // Offsets for second corner in (x,y,z,w) coords
        float fy1 = fy0 - j1 + G4;
        float fz1 = fz0 - k1 + G4;
        float fw1 = fw0 - l1 + G4;

        float fx2 = fx0 - i2 + 2.0f * G4; // Offsets for third corner in (x,y,z,w) coords
        float fy2 = fy0 - j2 + 2.0f * G4;
        float fz2 = fz0 - k2 + 2.0f * G4;
        float fw2 = fw0 - l2 + 2.0f * G4;

        float fx3 = fx0 - i3 + 3.0f * G4; // Offsets for fourth corner in (x,y,z,w) coords
        float fy3 = fy0 - j3 + 3.0f * G4;
        float fz3 = fz0 - k3 + 3.0f * G4;
        float fw3 = fw0 - l3 + 3.0f * G4;

        float fx4 = fx0 - 1.0f + 4.0f * G4; // Offsets for last corner in (x,y,z,w) coords
        float fy4 = fy0 - 1.0f + 4.0f * G4;
        float fz4 = fz0 - 1.0f + 4.0f * G4;
        float fw4 = fw0 - 1.0f + 4.0f * G4;

		ix0 &= 255;
		iy0 &= 255;
		iz0 &= 255;
		iw0 &= 255;
		float n = SimplexGradient(SimplexHash(ix0, iy0, iz0, iw0), fx0, fy0, fz0, fw0);
		float n1 = SimplexGradient(SimplexHash(ix0+i1, iy0+j1, iz0+k1, iw0+l1), fx1, fy1, fz1, fw1);
		float n2 = SimplexGradient(SimplexHash(ix0+i2, iy0+j2, iz0+k2, iw0+l2), fx2, fy2, fz2, fw2);
		float n3 = SimplexGradient(SimplexHash(ix0+i3, iy0+j3, iz0+k3, iw0+l3), fx3, fy3, fz3, fw3);
		float n4 = SimplexGradient(SimplexHash(ix0+1, iy0+1, iz0+1, iw0+1), fx4, fy4, fz4, fw4);

		float noise = 27f * (n+n1+n2+n3+n4);//[-1, 1]
		return (noise + 1) * 0.5f;
	}

    //二方连续
	//X, Y is [0..1]
	static public float SeamlessNoise( float x, float y, float dx, float dy, float xyOffset ) 
	{
	    float s = x;
	    float t = y;
 
	    float nx = xyOffset + Mathf.Cos(s * 2.0f * Mathf.PI) * dx / (2.0f * Mathf.PI);
	    float ny = xyOffset + Mathf.Cos(t * 2.0f * Mathf.PI) * dy / (2.0f * Mathf.PI);
	    float nz = xyOffset + Mathf.Sin(s * 2.0f * Mathf.PI) * dx / (2.0f * Mathf.PI);
	    float nw = xyOffset + Mathf.Sin(t * 2.0f * Mathf.PI) * dy / (2.0f * Mathf.PI);
 
	    return SimplexNoise(nx, ny, nz, nw);
	}

	static public float Noise(NoiseEnum type, float x, float y)
	{
		Noise2DFunction act = null;
		if(type == NoiseEnum.Perlin)
			act = PerlinNoise;
		else if(type == NoiseEnum.Simplex)
			act = SimplexNoise;

		if(act != null)
			return act.Invoke(x, y);
		else
			return 1f;
	}

	static public float Noise(NoiseEnum type, float x, float y, float z)
	{
		Noise3DFunction act = null;
		if(type == NoiseEnum.Perlin)
			act = PerlinNoise;
		else if(type == NoiseEnum.Simplex)
			act = SimplexNoise;

		if(act != null)
			return act.Invoke(x, y, z);
		else
			return 1f;
	}

	static public float Noise(NoiseEnum type, float x, float y, float z, float w)
	{
		Noise4DFunction act = null;
		if(type == NoiseEnum.Simplex)
			act = SimplexNoise;

		if(act != null)
			return act.Invoke(x, y, z, w);
		else
			return 1f;
	}

	//分形叠加
	//octave 倍率
	//frequency 频率
	//amplitudy 振幅
	static public float OcvateNoise(NoiseEnum type, float x, float y, int octave, float frequency, float amplitude)
	{
		float sum = 0;
		float freq = 1f;
		float amp = 1f;
		float maxValue = 0;// Used for normalizing result to 0.0 - 1.0
		for(int i = 0; i < octave; ++i)
		{
			sum += Noise(type, x * freq, y * freq) * amp;

			maxValue += amp;

			freq *= frequency;
			amp *= amplitude;
		}

		return sum / maxValue;
	}

	//分形叠加
	//octave 倍率
	//frequency 频率
	//amplitudy 振幅
	static public float OcvateNoise(NoiseEnum type, float x, float y, float z, int octave, float frequency, float amplitude)
	{
		float sum = 0;
		float freq = 1f;
		float amp = 1f;
		float maxValue = 0;// Used for normalizing result to 0.0 - 1.0
		for(int i = 0; i < octave; ++i)
		{
			sum += Noise(type, x * freq, y * freq, z * freq) * amp;

			maxValue += amp;

			freq *= frequency;
			amp *= amplitude;
		}

		return sum / maxValue;
	}

	//分形叠加
	//octave 倍率
	//frequency 频率
	//amplitudy 振幅
	static public float OcvateNoise(NoiseEnum type, float x, float y, float z, float w, int octave, float frequency, float amplitude)
	{
		float sum = 0;
		float freq = 1f;
		float amp = 1f;
		float maxValue = 0;// Used for normalizing result to 0.0 - 1.0
		for(int i = 0; i < octave; ++i)
		{
			sum += Noise(type, x * freq, y * freq, z * freq, w * freq) * amp;

			maxValue += amp;

			freq *= frequency;
			amp *= amplitude;
		}

		return sum / maxValue;
	}
}
