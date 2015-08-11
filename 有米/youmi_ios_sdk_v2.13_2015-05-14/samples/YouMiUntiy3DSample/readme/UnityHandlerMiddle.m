//
//  MyView.m
//  Unity-iPhone
//
//  Created by YANG ENZO on 13-1-10.
//
//

#import "UnityHandlerMiddle.h"
#import "ConfigHeader.h"


@implementation UnityHandlerMiddle


+ (UnityHandlerMiddle *)sharedInstance {
    static UnityHandlerMiddle *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [UnityHandlerMiddle new];
    });
    return instance;
}


- (id)init {
    self = [super init];
    if (self) {
        // **YouMi**
        // appid 设置
        [YouMiNewSpot initYouMiDeveloperParams:@" ***APP_ID*** " YM_SecretId:@" ***APP_SECRETID*** ”];//appid and appSecret
         
         [YouMiNewSpot initYouMiDeveLoperSpot: ***SPOTTYPE*** ];//ad type
        
        [YouMiNewSpot clickYouMiSpotAction:^(BOOL flag){
        }];
        
    }
    return self;
}

- (void)dealloc {

    [super dealloc];
}

void _initSpot() {
    [UnityHandlerMiddle sharedInstance];
    NSLog(@"初始化成功");
}

void _showSpot() {
    NSLog(@"show");
    [YouMiNewSpot showYouMiSpotAction:^(BOOL flag){
        if (flag) {
            NSLog(@"Show success. Do success thing");
        }
        else{
            NSLog(@"Show error. Do error thing");
        }
    }];
}

@end