//
//  ViewController.m
//  AdwoSDKDemo_launchingAd
//
//  Created by zenny_chen on 13-4-12.
//  Copyright (c) 2013年 zenny_chen. All rights reserved.
//

#import "ViewController.h"
#import "AdwoAdSDK.h"

@interface ViewController ()<AWAdViewDelegate>

@end

@implementation ViewController

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

- (void)loadView
{
    [super loadView];
    
    // 默认使用全屏模式
    self.wantsFullScreenLayout = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor blackColor];
    
    CGSize frameSize = [UIScreen mainScreen].bounds.size;
    
    // 这里先创建一个启动画面的图像视图，用于掩盖加载广告所需要的一小段时间
    CGFloat initY = -20.0f;
    if([[UIDevice currentDevice].systemVersion characterAtIndex:0] >= L'7')
        initY = 0.0f;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, initY, frameSize.width, frameSize.height)];
    imageView.tag = 13;
    imageView.image = frameSize.height > 480.0f? [UIImage imageNamed:@"Default-568h.png"] : [UIImage imageNamed:@"Default.png"];
    [self.view addSubview:imageView];
    [imageView release];
    
    // 然后创建mAdView，并使用测试模式。由于开屏广告的资源比较有限，因此用测试模式进行测试比较好。将全屏广告展现形式设置为开屏全屏
    mAdView = AdwoAdGetFullScreenAdHandle(@"ab8102cf6dfb4d99adaeeef8c038971f", YES, self, ADWOSDK_FSAD_SHOW_FORM_LAUNCHING);
    
    // 这里设置动画形式为无动画模式。如果不设置则由系统自动给出
    AdwoAdSetAdAttributes(mAdView, &(const struct AdwoAdPreferenceSettings){
        .animationType = ADWO_SDK_FULLSCREEN_ANIMATION_TYPE_NONE, .adSlotID = 0
    });
    
    // 开始加载全屏广告，并不锁定方向旋转
    
    mCanShowAd = AdwoAdLoadFullScreenAd(mAdView, NO, NULL);
    
    if(!mCanShowAd)
    {
        NSLog(@"%@", adwoResponseErrorInfoList[AdwoAdGetLatestErrorCode()]);
        [self performSelector:@selector(createControls:) withObject:@"Loading ad..." afterDelay:1.0];
    }
}

- (void)createControls:(NSString*)hint
{
    UIView *imageView = [self.view viewWithTag:13];
    if(imageView != nil)
        [imageView removeFromSuperview];
    
    self.view.backgroundColor = [UIColor grayColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 200.0f) * 0.5f, (self.view.frame.size.height - 35.0f) * 0.5f, 200.0f, 35.0f)];
    label.tag = 100;
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
    label.text = hint;
    [self.view addSubview:label];
    [label release];
}

- (void)adjustControlLayout
{
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    if(self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        CGFloat temp = width;
        width = height;
        height = temp;
    }
    
    UIView *label = [self.view viewWithTag:100];
    if(label == nil)
        return;
    label.frame = CGRectMake((width - 200.0f) * 0.5f, (height - 35.0f) * 0.5f, 200.0f, 35.0f);
}

#pragma mark - AWAdView delegates

// 此接口必须被实现，并且不能返回空！
- (UIViewController*)adwoGetBaseViewController
{
    return self;
}

- (void)adwoAdViewDidFailToLoadAd:(UIView*)adView
{
    NSLog(@"Failed to load ad! Because: %@", adwoResponseErrorInfoList[AdwoAdGetLatestErrorCode()]);
    
    // 加载全屏广告失败，将mAdView置空
    mAdView = nil;
    
    // 你这里可以再获得全屏广告对象来请求全屏广告
}

- (void)adwoAdViewDidLoadAd:(UIView*)adView
{
    NSLog(@"Ad did load!");
    
    // 若传递过来的视图并非自己设定的广告对象视图，则直接返回
    if(adView != mAdView)
        return;
    
    if(!mCanShowAd)
    {
        // 若当前开屏广告资源没准备好，则直接将mAdView置空
        NSLog(@"开屏广告资源已经下载好了");
        
        mAdView = nil;
    }
    else
    {
        // 广告加载成功，可以把全屏广告展示上去
        AdwoAdShowFullScreenAd(mAdView);
        mCanShowAd = NO;
    }
}

- (void)adwoFullScreenAdDismissed:(UIView*)adView
{
    NSLog(@"Full-screen ad closed by user!");
    
    // 这里直接将mAdView置空即可
    mAdView = nil;
    
    [self createControls:@"Ad has been shown"];
}

- (void)adwoDidPresentModalViewForAd:(UIView*)adView
{
    NSLog(@"Browser presented!");
}

- (void)adwoDidDismissModalViewForAd:(UIView*)adView
{
    NSLog(@"Browser dismissed!");
}

#pragma mark - screen orientation

/** 要同时支持横屏和竖屏切换，必须用以下方法 */

// 兼容iOS6.0以下系统
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    [self performSelector:@selector(adjustControlLayout) withObject:nil afterDelay:0.1];
    
    return YES;
}

// SDK将会在适当时刻通过代理接口-(UIViewController*)adwoGetBaseViewController所返回的控制器来调用此方法
- (BOOL)shouldAutorotate
{
    [self performSelector:@selector(adjustControlLayout) withObject:nil afterDelay:0.1];
    
    return YES;
}

#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

