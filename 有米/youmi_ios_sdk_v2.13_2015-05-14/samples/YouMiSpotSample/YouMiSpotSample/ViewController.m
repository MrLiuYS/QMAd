//
//  ViewController.m
//  YouMiSpotSample
//
//  Created by 陈建峰 on 14-7-11.
//  Copyright (c) 2014年 陈建峰. All rights reserved.
//

#import "ViewController.h"
#import "ConfigHeader.h"

#define YML_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define YML_SYSTEM_VERSION_GREATER_LESS_THEN(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == kCFCompareLessThan)

@interface ViewController ()
@end

@implementation ViewController

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return YES;
}
-(BOOL)shouldAutorotate{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#ifdef __IPHONE_7_0
    if ([[[UIDevice currentDevice] systemVersion] intValue] >= 7) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
#endif
    // Do any additional setup after loading the view, typically from a nib.
    //设置广告点击后的回调，可以不写。
    [NewWorldSpt clickQQWSPTAction:^(BOOL flag){
        //广告被点击的回调。
    }];
    
}
-(BOOL)isXCodeAutoRotation {
    CGRect bounds = [UIScreen mainScreen].bounds;
    
    if ( (bounds.size.height > bounds.size.width && YML_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) || YML_SYSTEM_VERSION_GREATER_LESS_THEN(@"8.0")
        ) {//7要转,8不用,且xcode5和xcode6编译也有区别.
        return YES;
    }
    return NO;
}
- (CGRect)getApplicationRealBounds {
    CGRect bounds = [UIScreen mainScreen].bounds;
    
    if ([self isXCodeAutoRotation]&&UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) ) {
        CGFloat width = bounds.size.width;
        bounds.size.width = bounds.size.height;
        bounds.size.height = width;
    }
    
    return CGRectMake(0, 0, bounds.size.width, bounds.size.height);
}
- (void)viewDidLayoutSubviews {
    CGRect frame = [self getApplicationRealBounds ];
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_demo.png"]];
    image.frame = frame;
    [self.view addSubview:image];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, height * 0.08, width, 60)];
    label.text = @"有米";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:25];
    label.textColor = [UIColor colorWithRed:63/255.0 green:136/255.0 blue:216/255.0 alpha:1.0];
    [self.view addSubview:label];
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(0, height * 0.18, width, 60)];
    label.text = @"iOS SDK V2.11";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor colorWithRed:63/255.0 green:136/255.0 blue:216/255.0 alpha:1.0];
    [self.view addSubview:label];
    
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button1.frame = CGRectMake((width - 164)/2, height/2, 164, 36);
    [button1 setTitle:@"插屏展示" forState:UIControlStateNormal];
    button1.titleLabel.font = [UIFont systemFontOfSize:14];
    [button1 setBackgroundImage:[UIImage imageNamed:@"btn.png"] forState:UIControlStateNormal];
    [button1.layer setCornerRadius:4.0];
    [button1.layer setMasksToBounds:YES];
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(spotSDKAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(0, height - 50, width, 40)];
    label.text = @"Powered by YouMi";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:10];
    label.textColor = [UIColor colorWithRed:63/255.0 green:136/255.0 blue:216/255.0 alpha:1.0];
    [self.view addSubview:label];
}


- (void)spotSDKAction:(UIButton *)sender{
    [NewWorldSpt showQQWSPTAction:^(BOOL flag){
        if (flag) {
            NSLog(@"log添加展示成功的逻辑");
        }
        else{
            NSLog(@"log添加展示失败的逻辑");
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
