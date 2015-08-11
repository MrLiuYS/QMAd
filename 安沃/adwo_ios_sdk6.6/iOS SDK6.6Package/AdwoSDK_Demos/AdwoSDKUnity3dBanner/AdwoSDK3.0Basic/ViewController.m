//
//  ViewController.m
//  AdwoSDK3.0Basic
//
//  Created by zenny_chen on 12-10-17.
//  Copyright (c) 2012年 zenny_chen. All rights reserved.
//

#import "ViewController.h"
#import "unity3DGetAd.h"



@interface ViewController()//<AWAdViewDelegate>
{
    unity3DGetAd *unityAd;

}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    unityAd = [[unity3DGetAd alloc] init];
    
	// Do any additional setup after loading the view, typically from a nib.
    
    // 展示广告按钮
    UIButton *showButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    showButton.frame = CGRectMake(60.0f, 30.0f, 90.0f, 35.0f);
    [showButton setTitle:@"Show ad" forState:UIControlStateNormal];
    [showButton addTarget:self action:@selector(showButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showButton];
    
    // 关闭广告按钮
    UIButton *stopButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    stopButton.frame = CGRectMake(170.0f, 30.0f, 90.0f, 35.0f);
    [stopButton setTitle:@"Close ad" forState:UIControlStateNormal];
    [stopButton addTarget:self action:@selector(stopButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopButton];
    
}



- (void)showButtonTouched:(UIButton*)sender
{
    [unityAd getAd];
}

- (void)stopButtonTouched:(UIButton*)sender
{
    [unityAd removeAd];
}



@end



