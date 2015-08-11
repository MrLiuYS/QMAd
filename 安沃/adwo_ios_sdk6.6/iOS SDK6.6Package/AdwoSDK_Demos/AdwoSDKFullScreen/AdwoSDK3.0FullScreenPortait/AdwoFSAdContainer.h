//
//  AdwoFSAdContainer.h
//  AdwoSDK3.0FullScreenPortait
//
//  Created by zenny_chen on 13-1-28.
//  Copyright (c) 2013年 zenny_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdwoFSAdContainer : NSObject
{
    UIView *fsNormalAd;
    UIView *fsLaunchingAd;
    UIView *fsBackToForeAd;
    UIViewController *baseViewController;
    
    BOOL isNormalAdLoaded;
    BOOL isLaunchingAdLoaded;
    BOOL isBackToForeAdReady;
    BOOL isAnAdIsShowing;
    
    NSObject *msgTarget;
    SEL  msgSelector;       // - (void)msgSelector:(AWAdView*)adView;
}

+ (void)startWithViewController:(UIViewController*)controller target:(NSObject*)obj adLoadedMsg:(SEL)aSelector;
+ (void)destroy;
+ (void)loadFSAds;
+ (void)switchViewContext:(UIViewController*)controller target:(NSObject*)obj adLoadedMsg:(SEL)aSelector;
+ (BOOL)loadLaunchingAd;
+ (void)showLaunchingAd;
+ (void)showNormalAd;

@end
