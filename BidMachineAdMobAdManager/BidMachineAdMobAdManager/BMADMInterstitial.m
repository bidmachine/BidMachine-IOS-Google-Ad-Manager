//
//  BMADMInterstitial.m
//  BidMachineAdMobAdManager
//
//  Created by Ilia Lozhkin on 5/15/20.
//  Copyright © 2020 Appodeal. All rights reserved.
//

#import "BMADMInterstitial.h"
#import "BMADMInterstitialAd.h"
#import "BMADMRewardedAd.h"

@interface BMADMInterstitial()

@property (nonatomic, strong) id<BMADMAdEventProtocol> fullscreenAd;

@end

@implementation BMADMInterstitial

- (instancetype)initWithUnitId:(NSString *)unitId rewarded:(BOOL)rewarded {
    if (self = [super init]) {
        if (rewarded) {
            _fullscreenAd = [[BMADMRewardedAd alloc] initWithUnitId:unitId];
        } else {
            _fullscreenAd = [[BMADMInterstitialAd alloc] initWithUnitId:unitId];
        }
    }
    return self;
}

- (void)loadAd {
    [self.fullscreenAd loadAd];
}

- (void)show:(UIViewController *)controller {
    [self.fullscreenAd show:controller];
}

- (BOOL)isLoaded {
   return [self.fullscreenAd isLoaded];
}

- (void)setDelegate:(id<BMADMAdEventDelegate>)delegate {
    self.fullscreenAd.delegate = delegate;
}

@end
