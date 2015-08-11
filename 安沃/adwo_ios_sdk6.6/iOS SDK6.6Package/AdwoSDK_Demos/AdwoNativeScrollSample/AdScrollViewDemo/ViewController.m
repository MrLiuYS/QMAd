//
//  ViewController.m
//  AdScrollViewDemo
//
//  Created by liujianan on 15/1/23.
//  Copyright (c) 2015年 liujianan. All rights reserved.
//

#import "ViewController.h"
#import "adwoSDK/AdwoAdSDK.h"

#define FRAME (self.view.frame.size)
#define ADWO_PID @"bd6eb6033d4a4418a87368280d23cd7c"

@interface ViewController ()<UIScrollViewDelegate,AWAdViewDelegate>
{
    UIView *myAdView;
    UIScrollView *myScrollView;
    BOOL adCanShow;
    UIView *customView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    adCanShow = NO;
    myAdView = nil;
    customView = nil;
    
    myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, FRAME.width, 200)];
    myScrollView.delegate = self;
    myScrollView.contentSize = CGSizeMake(FRAME.width*4, 200);
    myScrollView.showsHorizontalScrollIndicator = NO;
    myScrollView.showsVerticalScrollIndicator = NO;
    myScrollView.pagingEnabled = YES;
    
    NSArray *imageNames = [NSArray arrayWithObjects:@"1.png", @"2.png",@"3.png",@"4.png",nil];
    int i = 0;
    
    
    for (NSString *imageName in imageNames) {
        UIImage *image = [UIImage imageNamed:imageName];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(0+i*FRAME.width, 0, FRAME.width, 200);
        
        [myScrollView addSubview:imageView];
        [imageView release];
        i++;
    }
    
    
    [self.view addSubview:myScrollView];
    [self requestImplantAd];
}

- (void)requestImplantAd
{
    
    if (myAdView != nil) {
        return;
    }
    
    //请求信息流广告
    myAdView = AdwoAdCreateImplantAd(ADWO_PID, YES, self, nil, ADWOSDK_IMAD_SHOW_FORM_COMMON);
    
    // 加载信息流广告
    if(!AdwoAdLoadImplantAd(myAdView, NULL))
    {
        NSLog(@"植入性广告加载失败，由于：%d", AdwoAdGetLatestErrorCode());
        
        // 移除信息流广告对象
        AdwoAdRemoveAndDestroyImplantAd(myAdView);
        myAdView = nil;
    }
    else
        NSLog(@"加载成功");
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    //这里将广告展示在第4页
    if((myScrollView.contentOffset.x != FRAME.width*3) && adCanShow)
    {
        [myScrollView addSubview:customView];
        adCanShow = NO;
    }
}

- (UIViewController*)adwoGetBaseViewController
{
    return self;
}
- (void)adwoAdViewDidFailToLoadAd:(UIView*)adView
{
    NSLog(@"植入性广告请求失败，由于：%d", AdwoAdGetLatestErrorCode());
}
- (void)adwoAdViewDidLoadAd:(UIView*)adView
{
    //信息流广告所包含的资源在AdwoAdGetAdInfo中获取；
    NSLog(@"AdwoAdGetAdInfo = %@",AdwoAdGetAdInfo(myAdView));
    
    //这里转换为字典模式，方便提取
    NSString *str = AdwoAdGetAdInfo(myAdView);
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    //这里组织自定义的样式
    if (customView != nil) {
        [customView release];
        customView = nil;
    }
    customView = [[UIView alloc] initWithFrame:CGRectMake(FRAME.width*3, 0, FRAME.width, 200)];
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"img"]]];
    UIImage *image = [UIImage imageWithData:imageData];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, FRAME.width, 200)];
    imageView.image = image;
    
    [customView addSubview:imageView];
    
    
    //下发的广告透明模板都是默认屏幕尺寸，这里开发者根据自己需要的大小修改广告的尺寸
    myAdView.bounds = CGRectMake(0, 0, FRAME.width, 200);
    // 现在可以将其进行展示了
    AdwoAdShowImplantAd(myAdView, customView);
    // 激活植入性广告
    AdwoAdImplantAdActivate(myAdView);
    
    adCanShow = YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
