//
//  AppDelegate.m
//  TableViewPlaceholder
//
//  Created by lipengju on 2019/10/30.
//  Copyright © 2019 lipengju. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@property (nonatomic, strong) UINavigationController *navigationController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if ([UINavigationBar conformsToProtocol:@protocol(UIAppearanceContainer)]) {
        [UINavigationBar appearance].tintColor = [UIColor whiteColor];
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName : [UIColor whiteColor]}];
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:(51) / 255.f green:(171) / 255.f blue:(160) / 255.f alpha:1.f]];
        [[UINavigationBar appearance] setTranslucent:NO];
    }

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    ViewController *vc = [[ViewController alloc] init];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.window addSubview:vc.view];
    self.window.rootViewController = self.navigationController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
