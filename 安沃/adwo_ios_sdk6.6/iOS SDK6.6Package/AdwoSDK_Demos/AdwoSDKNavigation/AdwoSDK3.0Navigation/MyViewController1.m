//
//  MyViewController1.m
//  AdwoSDK3.0Navigation
//
//  Created by zenny_chen on 12-10-23.
//  Copyright (c) 2012年 zenny_chen. All rights reserved.
//

#import "MyViewController1.h"
#import "ViewController.h"
#import "MyViewController2.h"
#import "AdwoAdSDK.h"

@interface MyViewController1 ()<AWAdViewDelegate>

@end

@implementation MyViewController1

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
    [button setTitle:@"Next view" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    // 创建下一级视图控制器
    controller2 = [[MyViewController2 alloc] init];
}

- (void)buttonTouched:(id)sender
{
    // 在进入下一个控制器之前先释放当前的广告视图
    [baseViewController destroyBanner];
    
    // detatch全屏广告展示视图控制器
    [baseViewController clearShowAdViewController];
    
    [self.navigationController pushViewController:controller2 animated:YES];
    
    [controller2 setupBanner:baseViewController previousController:self];
}

- (void)setupBanner:(ViewController*)controller
{
    baseViewController = controller;
    [baseViewController createBanner:self];
    
    // 同时，加载全屏广告
    [baseViewController loadFSAd:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
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

