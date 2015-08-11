//
//  ViewController.m
//  AdwoSDK3.0FullScreenPortait
//
//  Created by zenny_chen on 12-10-20.
//  Copyright (c) 2012年 zenny_chen. All rights reserved.
//

#import "ViewController.h"
#import "unity3DGetFullScreenAd.h"


@interface ViewController()
{
    unity3DGetFullScreenAd *adView;
}
@end




@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    adView = [[unity3DGetFullScreenAd alloc] init];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.tag = 250;
    button.frame = CGRectMake((self.view.frame.size.width - 90.0f) * 0.5f, (self.view.frame.size.height - 35.0f) * 0.5f, 90.0f, 35.0f);
    [button setTitle:@"Request ad" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)showButtonTouched:(id)sender
{
    [adView getFullScreenAd];
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
