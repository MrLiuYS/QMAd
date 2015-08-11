//
//  MainViewController.m
//  ETADemo
//
//  Created by Zenny Chen on 14-5-16.
//  Copyright (c) 2014年 Adwo. All rights reserved.
//

#import "MainViewController.h"
#import "AdwoAdSDK.h"


#define ADWO_PUBLISH_ID_FOR_DEMO        @"ab8102cf6dfb4d99adaeeef8c038971f"

@interface MainViewController ()<AWAdViewDelegate>

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


@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 初始状态下可以关闭广告
    mCanCloseAd = YES;
    
    // 创建一个按钮用于指定展示哪一种ETA广告尺寸
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(40.0f, 40.0f, 90.0f, 35.0f);
    [button setTitle:@"0" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    // 启动ETA广告，并指定当前ETA广告类型为声纹广告
    if(AdwoAdLaunchETA(ADWOSDK_ETA_TYPE_VOICEPRINT, ADWO_PUBLISH_ID_FOR_DEMO, NO, &(const struct AdwoAdPreferenceSettings){.disableGPS = YES}))
    {
        // 设置ETA广告的delegate
        AdwoAdSetETADelegate(ADWOSDK_ETA_TYPE_VOICEPRINT, self);
    }
}

- (void)buttonTouched:(UIButton*)sender
{
    // 每次点击按钮时，让索引值加1
    mETAAdSizeIndex++;
    
    // 这里设定最大索引值为2
    if(mETAAdSizeIndex == 3)
        mETAAdSizeIndex = 0;
    
    [sender setTitle:[NSString stringWithFormat:@"%d", mETAAdSizeIndex] forState:UIControlStateNormal];
}

- (void)timerHandler:(NSTimer*)theTimer
{
    // 将定时器置空
    mTimer = nil;
    
    // 时间一到，判断是否可移除ETA广告视图对象
    if(mCanCloseAd)
    {
        // 若当前可移除广告，则直接移除
        AdwoAdRemoveETAViewFromSuperview(0);
    }
    else
        mNeedCloseAd = YES;     // 否则设置可关闭标志
}

#pragma mark - AWAdViewDelegate

- (UIViewController*)adwoGetBaseViewController
{
    return self;
}

- (void)adwoAdViewDidFailToLoadAd:(UIView*)adView
{
    int errCode = AdwoAdGetLatestErrorCode();
    NSString *info = adwoResponseErrorInfoList[errCode];
    
    NSLog(@"广告加载失败, 因为：%@", info);
    
    // 移除指定的ETA广告。ETA广告一旦被启用，SDK会自动做重新请求，开发者无需手工重新启动。
    AdwoAdRemoveETAViewFromSuperview(0);
}

- (void)adwoAdETAReceivedSpecifiedFeatureCode:(int)etaType
{
    CGSize sizeList[ADWOADSDK_MAX_ETA_AD_SIZES];
    int nAdSizes = AdwoAdGetETAViewSizes(ADWOSDK_ETA_TYPE_VOICEPRINT, sizeList);
    NSLog(@"当前ETA广告的尺寸数量为： %d", nAdSizes);
    
    // 过滤尺寸索引
    int index = 0;
    if(mETAAdSizeIndex < nAdSizes)
        index = mETAAdSizeIndex;
    
    // 将ETA广告加载到当前视图上，并将它剧中显示
    AdwoAdAddETAViewToSuperview(ADWOSDK_ETA_TYPE_VOICEPRINT, self.view, sizeList[index], CGPointMake((self.view.frame.size.width - sizeList[index].width) * 0.5f, (self.view.frame.size.height - sizeList[index].height) * 0.5f));
    
    // 定时20秒展示广告
    mTimer = [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(timerHandler:) userInfo:nil repeats:NO];
}

- (void)adwoUserClosedETA:(int)etaType
{
    // 若当前用于展示的定时器还在，则将它停止
    if(mTimer != nil)
    {
        [mTimer invalidate];
        mTimer = nil;
    }
    
    // 当用户点击了ETA广告里所附含的关闭按钮之后，广告当前的ETA广告
    AdwoAdRemoveETAViewFromSuperview(etaType);
}

- (void)adwoAdRequestShouldPause:(UIView*)adView
{
    // 当接收到此消息时，广告不可被关闭
    mCanCloseAd = NO;
}

- (void)adwoAdRequestMayResume:(UIView*)adView
{
    // 当接收到此消息后，广告可以被关闭
    mCanCloseAd = YES;
    
    // 若此时需要关闭广告，则将其关闭
    if(mNeedCloseAd)
    {
        mNeedCloseAd = NO;
        AdwoAdRemoveETAViewFromSuperview(ADWOSDK_ETA_TYPE_VOICEPRINT);
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end



