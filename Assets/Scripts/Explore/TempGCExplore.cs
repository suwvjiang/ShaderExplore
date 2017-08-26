using UnityEngine;
using System.Collections;
using System.Text;

/// <summary>
///
/// design by :江楚飞
/// date:2016
/// </summary>

public class TempGCExplore:MonoBehaviour
{
    private const int cnt = 500000;

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.W))
        {
            int i = cnt;
            UnityEngine.Profiling.Profiler.BeginSample("GCTest stringbuilder append");

            while (--i >= 0)
            {
                StringBuilder a = new StringBuilder();
                a.Append("jiangchufei");
                a.Append("A");
                a.Append("B");
                a.Append("C");
                a.Append("D");
            }
            UnityEngine.Profiling.Profiler.EndSample();
        }
        else if (Input.GetKeyDown(KeyCode.S))
        {
            int i = cnt;
            UnityEngine.Profiling.Profiler.BeginSample("GCTest string plus");

            while (--i >= 0)
            {
                string a = "";
                a += ("jiangchufei");
                a += ("A");
                a += ("B");
                a += ("C");
                a += ("D");
            }
            UnityEngine.Profiling.Profiler.EndSample();
        } 
        else if (Input.GetKeyDown(KeyCode.A))
        {
            int i = cnt;
            UnityEngine.Profiling.Profiler.BeginSample("GCTest string format");

            while (--i >= 0)
            {
                string a = string.Format("{0}{1}{2}{3}{4}", ("jiangchufei"), ("A"), ("B"), ("C"), ("D"));
            }
            UnityEngine.Profiling.Profiler.EndSample();
        } 
        else if (Input.GetKeyDown(KeyCode.D))
        {
            int i = cnt;
            UnityEngine.Profiling.Profiler.BeginSample("GCTest stringbuilder format");

            while (--i >= 0)
            {
                StringBuilder a = new StringBuilder();
                a.AppendFormat("{0}{1}{2}{3}{4}", ("jiangchufei"), ("A"), ("B"), ("C"), ("D"));
            }
            UnityEngine.Profiling.Profiler.EndSample();
        } 
        else if (Input.GetKeyDown(KeyCode.Q))
        {
            int i = cnt;
            UnityEngine.Profiling.Profiler.BeginSample("GCTest one stringbuilder append");

            StringBuilder a = new StringBuilder();
            while (--i >= 0)
            {
                a.Remove(0, a.Length);
                a.Append("jiangchufei");
                a.Append("A");
                a.Append("B");
                a.Append("C");
                a.Append("D");
            }
            UnityEngine.Profiling.Profiler.EndSample();
        } 
        else if (Input.GetKeyDown(KeyCode.E))
        {
            int i = cnt;
            UnityEngine.Profiling.Profiler.BeginSample("GCTest one stringbuilder format");

            StringBuilder a = new StringBuilder();
            while (--i >= 0)
            {
                a.Remove(0, a.Length);
                a.AppendFormat("{0}{1}{2}{3}{4}", ("jiangchufei"), ("A"), ("B"), ("C"), ("D"));
            }
            UnityEngine.Profiling.Profiler.EndSample();
        } 
    }
}
