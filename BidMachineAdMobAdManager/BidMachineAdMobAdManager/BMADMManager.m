//
//  BMADMManager.m
//  BidMachineAdMobAdManager
//
//  Created by Ilia Lozhkin on 5/18/20.
//  Copyright © 2020 Appodeal. All rights reserved.
//

#import "BMADMManager.h"
#import "BMADMNetworkEvent.h"
#import <BidMachine/BidMachine.h>

@implementation BMADMManager

+ (void)initialize:(NSString *)sellerId {
    BDMSdkConfiguration *configuration = [BDMSdkConfiguration new];
    [BDMSdk.sharedSdk startSessionWithSellerID:sellerId configuration:configuration completion:^{
        
    }];
}

@end
