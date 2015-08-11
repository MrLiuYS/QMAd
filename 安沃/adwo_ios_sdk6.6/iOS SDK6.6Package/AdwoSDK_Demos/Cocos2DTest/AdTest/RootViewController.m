//
//  RootViewController.m
//  AdTest
//
//  Created by fei` on 12-12-18.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

//
// RootViewController + iAd
// If you want to support iAd, use this class as the controller of your iAd
//

#import "cocos2d.h"

#import "RootViewController.h"
#import "GameConfig.h"
#import "AdwoAdSDK.h"

@interface RootViewController()<AWAdViewDelegate>

@end

static NSString* const adwoResponseErrorInfoList[] = {
    @"操作成功",
    @"广告初始化失败",
    @"当前广告已调用了加载接口",
    @"不该为空的参数为空",
    @"参数值非法",
    @"非法广告对象句柄",
    @"代理为空或adwoGetBaseViewController方法没实现",
    @"非法的广告对象句柄引用计数",
    @"意料之外的错误",
    @"广告请求太过频繁",
    @"广告加载失败",
    @"全屏广告已经展示过",
    @"全屏广告还没准备好来展示",
    @"全屏广告资源破损",
    @"开屏全屏广告正在请求",
    @"当前全屏已设置为自动展示",
    @"当前事件触发型广告已被禁用",
    @"没找到相应合法尺寸的事件触发型广告",
    
    @"服务器繁忙",
    @"当前没有广告",
    @"未知请求错误",
    @"PID不存在",
    @"PID未被激活",
    @"请求数据有问题",
    @"接收到的数据有问题",
    @"当前IP下广告已经投放完",
    @"当前广告都已经投放完",
    @"没有低优先级广告",
    @"开发者在Adwo官网注册的Bundle ID与当前应用的Bundle ID不一致",
    @"服务器响应出错",
    @"设备当前没连网络，或网络信号不好",
    @"请求URL出错"
};

@implementation RootViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
	// Custom initialization
	}
	return self;
 }
 */

extern BOOL AdwoAdSetDelegate(UIView *adView, NSObject<AWAdViewDelegate> *delegate);

 // Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
}

#define ADWO_PUBLISH_ID_FOR_DEMO        @"ab8102cf6dfb4d99adaeeef8c038971f"

- (void)createFullAd
{
    // 若插屏广告对象已存在，则直接返回
    if(fsAdView != nil)
        return;
    
    // 获取插屏广告对象
    fsAdView = AdwoAdGetFullScreenAdHandle(ADWO_PUBLISH_ID_FOR_DEMO, YES, self, ADWOSDK_FSAD_SHOW_FORM_APPFUN_WITH_BRAND);
    
    AdwoAdSetDelegate(fsAdView, self);
    
    if(fsAdView == nil)
    {
        NSLog(@"AWAdView failed to create!");
        return;
    }
    
    // 加载插屏幕广告，并且设置锁定旋转，以减少所要加载的素材尺寸
    if(!AdwoAdLoadFullScreenAd(fsAdView, YES, NULL))
    {
        NSLog(@"全屏广告加载失败，由于：%@", adwoResponseErrorInfoList[AdwoAdGetLatestErrorCode()]);
        
        // 全屏加载失败，SDK将会自动销毁此对象，这里只需要将全屏广告对象引用置空即可
        fsAdView = nil;
        
        // 过5秒后重新尝试请求
        [self performSelector:@selector(createFullAd) withObject:nil afterDelay:5.0];
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
	//[super viewDidLoad];
    
    [self createFullAd];
}

#pragma mark - AWAdviewDelegate

- (UIViewController*)adwoGetBaseViewController
{
    return self;
}

- (void)adwoAdViewDidFailToLoadAd:(AWAdView*)adView
{
    NSLog(@"Failed to load ad! Because: %@", adwoResponseErrorInfoList[AdwoAdGetLatestErrorCode()]);
    
    // 加载全屏广告失败，由于adView尚未被加载到一个父视图上
    fsAdView = nil;
    
    // 你这里可以再创建全屏广告对象来请求全屏广告
    // 要再次请求插屏广告至少得延迟1秒时间
    // 这里延迟10秒后再次请求
    [self performSelector:@selector(createFullAd) withObject:nil afterDelay:10.0];
}

- (void)adwoAdViewDidLoadAd:(AWAdView*)adView
{
    NSLog(@"Ad did load!");
    
    NSLog(@"view size is: %fx%f", self.view.bounds.size.width, self.view.bounds.size.height);
    
    
    // 广告加载成功，可以把全屏广告展示上去
    AdwoAdShowFullScreenAd(fsAdView);
}

- (void)adwoFullScreenAdDismissed:(AWAdView*)adView
{
    NSLog(@"Full-screen ad closed by user!");
    
    // 插屏广告被用户关闭，此时可以尝试加载新的插屏广告
    fsAdView = nil;
    
    // 要再次请求插屏广告至少得延迟3秒时间，这里延迟10秒后再次请求
    [self performSelector:@selector(createFullAd) withObject:nil afterDelay:10.0];
}

#pragma mark - orientation relevant

// 兼容iOS6.0以下系统
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight)
        return YES;
    
    return NO;
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [super dealloc];
}

@end

