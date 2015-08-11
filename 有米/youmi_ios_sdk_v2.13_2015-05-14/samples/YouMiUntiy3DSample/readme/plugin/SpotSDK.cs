using UnityEngine;
using System.Runtime.InteropServices;

public class SpotSDK : MonoBehaviour{
	
	[DllImport("__Internal")]
	private static extern void _initSpot();
	[DllImport("__Internal")]
	private static extern void _showSpot();
	
	public static void InitSpot()
	{
		if (Application.platform != RuntimePlatform.OSXEditor)
		{
			_initSpot();
		}
	}
	
	public static void ShowSpot()
	{
		if (Application.platform != RuntimePlatform.OSXEditor)
		{
			_showSpot();
		}
	}

}