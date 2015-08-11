//
//  MainViewController.h
//  ETADemo
//
//  Created by Zenny Chen on 14-5-16.
//  Copyright (c) 2014年 Adwo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController
{
@private
    
    int mETAAdSizeIndex;
    NSTimer *mTimer;
    BOOL mCanCloseAd;
    BOOL mNeedCloseAd;
}

@end
