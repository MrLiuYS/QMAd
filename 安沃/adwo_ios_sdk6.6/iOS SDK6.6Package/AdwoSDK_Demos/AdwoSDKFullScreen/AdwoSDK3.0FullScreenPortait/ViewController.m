//
//  ViewController.m
//  AdwoSDK3.0FullScreenPortait
//
//  Created by zenny_chen on 12-10-20.
//  Copyright (c) 2012年 zenny_chen. All rights reserved.
//

#import "ViewController.h"
#import "AdwoAdSDK.h"
#import "AdwoFSAdContainer.h"

@interface ViewController()

@end


@implementation ViewController

- (void)setMainViewLayout
{
    self.view.backgroundColor = [UIColor grayColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(30.0f, 10.0f, 90.0f, 35.0f);
    [button setTitle:@"Show ad" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(140.0f, 10.0f, 90.0f, 35.0f);
    [button setTitle:@"Close ad" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closeButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor blackColor];
    
    [AdwoFSAdContainer startWithViewController:self target:self adLoadedMsg:@selector(fsAdDidLoad:)];
    if(![AdwoFSAdContainer loadLaunchingAd])
        [self setMainViewLayout];
    
    [AdwoFSAdContainer loadFSAds];
}

#define ADWO_PUBLISH_ID_FOR_DEMO        @"ab8102cf6dfb4d99adaeeef8c038971f"

- (void)showButtonTouched:(id)sender
{
    [AdwoFSAdContainer showNormalAd];
}

- (void)closeButtonTouched:(id)sender
{
    [AdwoFSAdContainer destroy];
}

- (void)fsAdDidLoad:(AWAdView*)adView
{
    [AdwoFSAdContainer showLaunchingAd];
    [self setMainViewLayout];
}


#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - screen orientation

/** 要支持横屏和竖屏切换，必须使用以下方法 */

// 兼容iOS6.0以下系统
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{    
    return YES;
}

// 兼容iOS6.0及以上版本
- (BOOL)shouldAutorotate
{
    return YES;
}

@end
