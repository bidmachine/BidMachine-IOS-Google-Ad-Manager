//
//  BMADMNetworkEvent.h
//  BidMachineAdMobAdManager
//
//  Created by Ilia Lozhkin on 25.05.2020.
//  Copyright © 2020 Appodeal. All rights reserved.
//

#import <BidMachine/BidMachine.h>

typedef NS_ENUM(NSUInteger, BMADMEvent) {
    BMADMEventBMRequestStart,
    BMADMEventBMRequestFail,
    BMADMEventBMRequestSuccess,
    BMADMEventGAMLoadStart,
    BMADMEventGAMLoaded,
    BMADMEventGAMFailToLoad,
    BMADMEventGAMAppEvent,
    BMADMEventGAMMetadata,
    BMADMEventBMLoadStart,
    BMADMEventBMLoaded,
    BMADMEventBMFailToLoad,
    BMADMEventBMIsLoaded,
    BMADMEventBMClicked,
    BMADMEventBMShow,
    BMADMEventBMShown,
    BMADMEventBMClosed,
    BMADMEventBMReward,
    BMADMEventBMFailToShow,
    BMADMEventBMExpired,
    BMADMEventBMBannerAPIShow,
    BMADMEventBMBannerAPIHide
};

typedef NS_ENUM(NSUInteger, BMADMEventType) {
    BMADMEventTypeBanner,
    BMADMEventTypeInterstitial,
    BMADMEventTypeRewarded
};



@interface BMADMNetworkEvent : NSObject

@property (nonatomic, weak) BDMRequest *request;
@property (nonatomic, assign) BMADMEventType adType;

- (void)trackEvent:(BMADMEvent)event customParams:(NSDictionary <NSString *, NSString *> *)customParams;

- (void)trackError:(NSError *)error event:(BMADMEvent)event customParams:(NSDictionary <NSString *, NSString *> *)customParams internal:(BOOL)internal;

@end
