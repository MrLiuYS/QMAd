//
//  MyViewController2.m
//  AdwoSDK3.0Navigation
//
//  Created by zenny_chen on 12-10-23.
//  Copyright (c) 2012年 zenny_chen. All rights reserved.
//

#import "MyViewController2.h"
#import "MyViewController1.h"
#import "ViewController.h"
#import "AdwoAdSDK.h"

@interface MyViewController2 ()<AWAdViewDelegate>

@end

@implementation MyViewController2

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
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(100.0f, 100.0f, 120.0f, 35.0f);
    [button setTitle:@"Previous view" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonTouched:(id)sender
{
    // 在返回到上一个视图控制器之前，先释放当前的广告视图
    [baseViewController destroyBanner];
    
    // detatch全屏广告展示视图控制器
    [baseViewController clearShowAdViewController];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    // 这里延迟0.8秒，为了能让前一级的视图控制器完全呈现后再做Banner与全屏加载，这样控制台里不会显示出warning
    [previousViewController performSelector:@selector(setupBanner:) withObject:baseViewController afterDelay:0.8];
}

- (void)setupBanner:(ViewController*)baseController previousController:(MyViewController1*)previousController
{
    previousViewController = previousController;
    baseViewController = baseController;
    [baseViewController createBanner:self];
    
    // 同时，加载全屏广告
    // 这里延迟0.8秒，为了能让前一级的视图控制器完全呈现后再做Banner与全屏加载，这样控制台里不会显示出warning
    [baseViewController performSelector:@selector(loadFSAd:) withObject:self afterDelay:0.8];
}

#pragma mark - Adwo Ad delegates

// 这个接口必须被实现，并且不能返回空！
- (UIViewController*)adwoGetBaseViewController
{
    return self;
}


#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

