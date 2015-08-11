//
//  MainViewController.h
//  ETAWithBannerDemo
//
//  Created by Zenny Chen on 14-5-20.
//  Copyright (c) 2014年 Adwo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController
{
    UIView *mBannerAd;
    
    NSTimer *mAdTimer;
    
    BOOL mCanRemoveAd;
    BOOL mCanShowVoicePrint;
    BOOL mNeedCloseBanner;
    BOOL mNeedCloseVoicePrint;
    
    BOOL mDestroyWholeAd;
}

@end

