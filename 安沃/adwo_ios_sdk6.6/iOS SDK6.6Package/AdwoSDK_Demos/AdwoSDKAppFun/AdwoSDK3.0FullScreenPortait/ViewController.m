//
//  ViewController.m
//  AdwoSDK3.0FullScreenPortait
//
//  Created by zenny_chen on 12-10-20.
//  Copyright (c) 2012年 zenny_chen. All rights reserved.
//

#import "ViewController.h"
#import "AdwoAdSDK.h"

#define ADWO_PUBLISH_ID_FOR_DEMO        @"bf68f2de53404066b359659d4515d94b"

@interface ViewController()<AWAdViewDelegate>
{
    UIView *AdView;
}
@end




@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
  
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.tag = 250;
    button.frame = CGRectMake((self.view.frame.size.width - 90.0f) * 0.5f, (self.view.frame.size.height - 35.0f) * 0.5f, 90.0f, 35.0f);
    [button setTitle:@"Request ad" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)showButtonTouched:(id)sender
{
    if(AdView != nil)
        return;
    
    // 初始化AWAdView对象
    AdView = AdwoAdGetFullScreenAdHandle(ADWO_PUBLISH_ID_FOR_DEMO, YES, self, ADWOSDK_FSAD_SHOW_FORM_APPFUN_WITH_BRAND);
    if(AdView == nil)
    {
        NSLog(@"Adwo full-screen ad failed to create!");
        return;
    }
    
    // 这里使用ADWO_ADSDK_AD_TYPE_FULL_SCREEN标签来加载全屏广告
    // 全屏广告是立即加载的，因此不需要设置adRequestTimeIntervel属性，当然也不需要设置其frame属性
    if(!AdwoAdLoadFullScreenAd(AdView, NO, NULL))
    {
        NSLog(@"加载失败，由于：%d", AdwoAdGetLatestErrorCode());
        AdView = nil;  // 若加载失败，则SDK将会自动销毁当前的全屏广告对象，此时将全屏广告对象引用置空即可
    }
}
#pragma mark - ad delegate
// 此接口必须被实现，并且不能返回空！
- (UIViewController*)adwoGetBaseViewController
{
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}

- (void)adwoAdViewDidFailToLoadAd:(UIView*)ad
{
    NSLog(@"Failed to load ad! Because: %d",AdwoAdGetLatestErrorCode());
    
    AdView = nil;
}

- (void)adwoAdViewDidLoadAd:(UIView*)ad
{
    NSLog(@"Ad did load!");
    
    // 广告加载成功，可以把全屏广告展示上去
    AdwoAdShowFullScreenAd(AdView);
}

- (void)adwoFullScreenAdDismissed:(UIView*)ad
{
    NSLog(@"Full-screen ad closed by user!");
    AdView = nil;
}

- (void)adwoDidPresentModalViewForAd:(UIView*)ad
{
    NSLog(@"Browser presented!");
}

- (void)adwoDidDismissModalViewForAd:(UIView*)ad
{
    NSLog(@"Browser dismissed!");
}
#pragma mark - Orientation processing

- (void)adjustButtonLayout
{
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    
    if(self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        CGFloat tmp = width;
        width = height;
        height = tmp;
    }
    
    UIView *button = [self.view viewWithTag:250];
    button.frame = CGRectMake((width - 90.0f) * 0.5f, (height - 35.0f) * 0.5f, 90.0f, 35.0f);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    [self performSelector:@selector(adjustButtonLayout) withObject:nil afterDelay:0.1];
    
    return YES;
}

- (BOOL)shouldAutorotate
{
    [self performSelector:@selector(adjustButtonLayout) withObject:nil afterDelay:0.1];
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
