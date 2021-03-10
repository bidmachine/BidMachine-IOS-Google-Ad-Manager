//
//  AppDelegate.m
//  AdMobManagerBidMachineSample
//
//  Created by Ilia Lozhkin on 5/15/20.
//  Copyright © 2020 Appodeal. All rights reserved.
//

#import "AppDelegate.h"
#import <BidMachineAdMobAdManager/BidMachineAdMobAdManager.h>


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
 
    [BMADMManager initialize:@"127"];
    
    // Override point for customization after application launch.
    return YES;
}

@end
