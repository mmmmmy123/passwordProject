//
//  AppDelegate+HT.m
//  XuanYuan
//
//  Created by 聂嗣洋 on 2017/4/30.
//  Copyright © 2017年 聂嗣洋. All rights reserved.
//

#import "AppDelegate+HT.h"
#import "HTAddItemsViewController.h"
#import "HTNavigationController.h"
#import "HTCheckViewController.h"
#import "DetailCopyViewController.h"


@implementation AppDelegate (HT)


-(void)setMainRootViewController
{
    HTTabBarController *tabbar = instantiateStoryboardControllerWithIdentifier(@"HTTabBarController");
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = tabbar;
    [self.window makeKeyAndVisible];
}

-(void)setShortcutIcon
{
    UIApplicationShortcutIcon *addShortcutIcon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeAdd];
    UIApplicationShortcutItem *addShortcutItem = [[UIApplicationShortcutItem alloc] initWithType:@"cn.niesiyang.add" localizedTitle:@"添加账号" localizedSubtitle:@"创建一个新的账号信息" icon:addShortcutIcon userInfo:nil];
    
    UIApplicationShortcutIcon *bigbangShortcutIcon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeBookmark];
    UIApplicationShortcutItem *bigbangShortcutItem = [[UIApplicationShortcutItem alloc] initWithType:@"cn.niesiyang.bigbang" localizedTitle:@"分词" localizedSubtitle:@"将您剪贴板中的内容分词复制" icon:bigbangShortcutIcon userInfo:nil];
    
    [UIApplication sharedApplication].shortcutItems = @[addShortcutItem,bigbangShortcutItem];
}



-(void)openAddViewController
{
    HTAddItemsViewController *vc = [[HTAddItemsViewController alloc]init];
    HTNavigationController *nextnav = [[HTNavigationController alloc]initWithRootViewController:vc];
    
    HTTabBarController *tab = MainRootTabbarController;
    HTNavigationController *nav = tab.selectedViewController;
    [nav.viewControllers.firstObject presentViewController:nextnav animated:YES completion:nil];
}



-(void)openUrlFromWeiMi:(NSURL *)url
{
    if ([url.host isEqualToString:@"BigBang"]) {
        [self openBigBangViewController];
    }
}


-(void)openBigBangViewController
{
    ClassificationModel *model = [[ClassificationModel alloc]init];
    UIPasteboard*pasteboard = [UIPasteboard generalPasteboard];
    model.remarks = pasteboard.string;
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    DetailCopyViewController *vc = [sb instantiateViewControllerWithIdentifier:@"DetailCopyViewController"];
    vc.model = model;
    vc.isPeek = NO;
    vc.isBigBang = YES;
    [[HTTools getCurrentVC] presentViewController:vc animated:NO completion:^{}];
}




//进入验证界面
-(void)checkController
{
    
    UIViewController *currentvc = [HTTools getCurrentVC];
    if ([currentvc isKindOfClass:[HTCheckViewController class]]) {
        return;
    }
    
    [self.backgroundView removeFromSuperview];
    UIImageView *imageView = [HTTools gaussianBlurWithMainRootView];
    self.backgroundView = imageView;
    [MainKeyWindow addSubview:self.backgroundView];
    BOOL isOpenPassword = [MainConfigManager isOpenStartPassword];
    
    NSString *password = [MainConfigManager startPassword];
    
    if (isOpenPassword &&! [HTTools ht_isBlankString:password]) {
        HTCheckViewController *vc = instantiateStoryboardControllerWithIdentifier(@"HTCheckViewController");
        vc.image = imageView;
        [currentvc presentViewController:vc animated:YES completion:^{}];
    }
}

/**
 启动时进入
 */
-(void)launchCheck
{
    BOOL isOpenPassword = [MainConfigManager isOpenStartPassword];
    NSString *password = [MainConfigManager startPassword];
    
    if (isOpenPassword && ![HTTools ht_isBlankString:password]) {
        UIImageView *imageView = [HTTools gaussianBlurWithMainRootView];
        HTCheckViewController *vc = instantiateStoryboardControllerWithIdentifier(@"HTCheckViewController");
        vc.image = imageView;
        [MainRootViewController presentViewController:vc animated:YES completion:^{}];
    }
}


@end
