//
//  MyViewController2.h
//  AdwoSDK3.0Navigation
//
//  Created by zenny_chen on 12-10-23.
//  Copyright (c) 2012年 zenny_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;
@class MyViewController1;

@interface MyViewController2 : UIViewController
{
    UIView *adView;
    ViewController *baseViewController;
    MyViewController1 *previousViewController;
}

- (void)setupBanner:(ViewController*)baseController previousController:(MyViewController1*)previousController;

@end
