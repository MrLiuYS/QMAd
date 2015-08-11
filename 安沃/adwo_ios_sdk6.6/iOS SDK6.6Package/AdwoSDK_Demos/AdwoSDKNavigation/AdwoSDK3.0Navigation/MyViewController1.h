//
//  MyViewController1.h
//  AdwoSDK3.0Navigation
//
//  Created by zenny_chen on 12-10-23.
//  Copyright (c) 2012年 zenny_chen. All rights reserved.
//

#import "AdwoAdSDK.h"

@class MyViewController2;
@class ViewController;

@interface MyViewController1 : UIViewController<AWAdViewDelegate>
{
    MyViewController2 *controller2;
    ViewController *baseViewController;
}

- (void)setupBanner:(ViewController*)controller;

@end

