//
//  ViewController.h
//  ImplantAdSample
//
//  Created by Zenny Chen on 14-1-7.
//  Copyright (c) 2014年 Adwo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    UIView *mAdView;            // 广告对象句柄
    BOOL mMayBeClosed;          // 判定是否可销毁植入性广告对象
}

@end
