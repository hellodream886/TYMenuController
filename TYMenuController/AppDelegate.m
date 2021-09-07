//
//  AppDelegate.m
//  TYMenuController
//
//  Created by TY on 2021/9/7.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    ViewController *vc = [[ViewController alloc] init];
    
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];

    return YES;
}



@end
