//
//  MyIOSSdk.m
//  AdwoSDK3.0FullScreenPortait
//
//  Created by liujianan on 15/3/6.
//  Copyright (c) 2015年 zenny_chen. All rights reserved.
//

#import "MyIOSSdk.h"


//A
#if defined(__cplusplus)
extern "C"{
#endif
    extern void UnitySendMessage(const char *,const char*,const char*);
    extern NSString * CreateNSString(const char *string);
#if defined(__cplusplus)
}
#endif

    
@implementation MyIOSSdk

+(void)sendU3dMessage:(NSString *)messageName param:(NSDictionary *)dict
{
    NSString *param = @"";
    if (dict != nil) {
        for (NSString *key in dict) {
            if ([param length] == 0)
            {
                param = [param stringByAppendingFormat:@"%@=%@", key, [dict valueForKey:key]];
            }
            else
            {
                param = [param stringByAppendingFormat:@"&%@=%@", key, [dict valueForKey:key]];
            }
        }
    }
    
    UnitySendMessage("SDK_Object", [messageName UTF8String], [param UTF8String]);
}

- (void)SDKInit
{
    //sdk初始化
}









@end
