objective-c项目嵌入YouMiSDK例子说明文档
===

1.运行例子,注意修改AppDelegate.m里的这两个地方
		
	//appid和appsecret
	NSString *appid = @"YOUR_Appid";
    NSString *secretId = @"YOUR_Secret";
    
    //应用的横竖屏情况.
    [YouMiNewSpot initYouMiDeveLoperSpot:kSPOTSpotTypeLandscape];