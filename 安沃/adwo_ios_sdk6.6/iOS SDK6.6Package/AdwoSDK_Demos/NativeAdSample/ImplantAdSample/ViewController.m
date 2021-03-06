//
//  ViewController.m
//  ImplantAdSample
//
//  Created by Zenny Chen on 14-1-7.
//  Copyright (c) 2014年 Adwo. All rights reserved.
//

#import "ViewController.h"
#import "AdwoAdSDK.h"

#define ADWO_PUBLISH_ID_FOR_DEMO        @"536a9c813d1a47f8a6a56b55638d904e"
@interface ViewController ()<AWAdViewDelegate>

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

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(20.0f, 50.0f, 100.0f, 35.0f);
    [button setTitle:@"请求广告" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(requestButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(120.0f, 50.0f, 100.0f, 35.0f);
    [button setTitle:@"关闭广告" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closeButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    mMayBeClosed = YES;     // 初始状态，可以销毁植入性广告对象
}

- (void)requestButtonTouched:(id)obj
{
    if(mAdView != nil)
        return;
    
    // 创建一个原生广告对象，最后一个参数控制请求视频激励原生广告还是普通原生广告
    mAdView = AdwoAdCreateImplantAd(ADWO_PUBLISH_ID_FOR_DEMO, YES, self, nil, ADWOSDK_IMAD_SHOW_FORM_COMMON);
    
    // 加载原生广告
    if(!AdwoAdLoadImplantAd(mAdView, NULL))
    {
        NSLog(@"原生广告加载失败，由于：%@", adwoResponseErrorInfoList[AdwoAdGetLatestErrorCode()]);
        
        // 移除原生广告对象
        AdwoAdRemoveAndDestroyImplantAd(mAdView);
        mAdView = nil;
    }
    else
        NSLog(@"加载成功");
}


- (void)closeButtonTouched:(id)obj
{
    if(!mMayBeClosed)
        return;
    
    if(mAdView != nil)
    {
        AdwoAdRemoveAndDestroyImplantAd(mAdView);
        mAdView = nil;
    }
}

#pragma mark - Adwo Ad delegates

- (UIViewController*)adwoGetBaseViewController
{
    return self;
}

- (void)adwoAdViewDidFailToLoadAd:(UIView*)adView
{
    NSLog(@"原生广告请求失败，由于：%@", adwoResponseErrorInfoList[AdwoAdGetLatestErrorCode()]);
}

- (void)adwoAdViewDidLoadAd:(UIView*)adView
{
    //获取AdInfo中的广告信息
    //将adInfo转化为Dictionary格式，方便提取
    NSString *str = AdwoAdGetAdInfo(mAdView);
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSLog(@"adinfo is :%@",dic);
    
    //开发者在这里做图片提取与视图模板组织工作
    
    
    // 原生广告尺寸默认是当前屏幕大小，这里开发者可以根据需求自己设置广告的尺寸
    CGSize size = CGSizeMake(200, 200);
    
    // 然后根据当前尺寸，可以设定植入性广告的位置
    adView.frame = CGRectMake((self.view.frame.size.width - size.width) * 0.5f, self.view.frame.size.height - size.height - 50.0f, size.width, size.height);
    
    // 现在可以将其进行展示了。当然，展示也可稍后再做
    AdwoAdShowImplantAd(adView, self.view);
    
    // 激活原生广告
    AdwoAdImplantAdActivate(mAdView);
    
    
}

- (void)adwoAdRequestShouldPause:(UIView*)adView
{
    mMayBeClosed = NO;
}

- (void)adwoAdRequestMayResume:(UIView*)adView
{
    mMayBeClosed = YES;
}

#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


