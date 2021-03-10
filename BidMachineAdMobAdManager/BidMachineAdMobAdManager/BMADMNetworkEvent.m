//
//  BMADMNetworkEvent.m
//  BidMachineAdMobAdManager
//
//  Created by Ilia Lozhkin on 25.05.2020.
//  Copyright © 2020 Appodeal. All rights reserved.
//

#import "BMADMNetworkEvent.h"
#import <StackFoundation/StackFoundation.h>

static NSString *eventBaseUrl = @"https://event.bidmachine.io";
static NSString *sessionUUID = nil;

#define QUERY_EVENT                 "event"

@interface BMADMNetworkEvent ()

@property (nonatomic, strong) NSString *requestId;

@end

@implementation BMADMNetworkEvent

- (instancetype)init {
    if (self = [super init]) {
        _requestId = NSUUID.UUID.UUIDString;
    }
    return self;
}

- (NSString *)sessionId {
    if (!sessionUUID) {
        sessionUUID = NSUUID.UUID.UUIDString;
    }
    return sessionUUID;
}

- (void)trackEvent:(BMADMEvent)event customParams:(NSDictionary<NSString *,NSString *> *)customParams {
    [self trackError:nil event:event customParams:customParams internal:NO];
}

- (void)trackError:(NSError *)error event:(BMADMEvent)event customParams:(NSDictionary<NSString *,NSString *> *)customParams internal:(BOOL)internal {
    NSMutableArray *queries = NSMutableArray.new;
    [queries addObject: [NSURLQueryItem queryItemWithName:@"event" value:[self eventString:event]]];
    
    if (error && internal) {
        [queries addObject: [NSURLQueryItem queryItemWithName:@"error_code_message" value:@"INTERNAL_ERROR"]];
        [queries addObject: [NSURLQueryItem queryItemWithName:@"error_code" value:@(error.code).stringValue]];
    } else if (error) {
        [queries addObject: [NSURLQueryItem queryItemWithName:@"bm_error" value:@(error.code).stringValue]];
    } else {
        [queries addObject: [NSURLQueryItem queryItemWithName:@"bm_error" value:@"ERROR WAS NILL"]];
    }
    
    [queries addObject: [NSURLQueryItem queryItemWithName:@"bm_pf_clear" value:self.request.info.price.stringValue]];
    [queries addObject: [NSURLQueryItem queryItemWithName:@"ad_type" value:[self eventAdTypeString:self.adType]]];
    
    [queries addObjectsFromArray:self.baseItems];
    [queries addObjectsFromArray:[self queryItemsFromCustomParams:customParams]];
    [self makeRequestWithQueries:queries];
}

- (NSArray <NSURLQueryItem *> *)baseItems {
    return @[[NSURLQueryItem queryItemWithName:@"integration_type" value:@"GAM"],
             [NSURLQueryItem queryItemWithName:@"bm_platform" value:@"ios"],
             [NSURLQueryItem queryItemWithName:@"session_id" value:self.sessionId],
             [NSURLQueryItem queryItemWithName:@"request_id" value:self.requestId],
             [NSURLQueryItem queryItemWithName:@"time_stamp" value:@(NSDate.stk_currentTimeInSeconds).stringValue],
             [NSURLQueryItem queryItemWithName:@"bm_network_key" value:self.request.info.demandSource],
             [NSURLQueryItem queryItemWithName:@"bm_version" value:kBDMVersion],
             [NSURLQueryItem queryItemWithName:@"app_version" value:STKBundle.bundleVersion],
             [NSURLQueryItem queryItemWithName:@"bundle_id" value:STKBundle.ID]];
}

- (NSArray <NSURLQueryItem *> *)queryItemsFromCustomParams:(NSDictionary<NSString *,NSString *> *)customParams {
    NSMutableArray *queries = NSMutableArray.new;
    [customParams enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        [queries addObject: [NSURLQueryItem queryItemWithName:key value:obj]];
    }];
    return queries;
}

- (void)makeRequestWithQueries:(NSArray <NSURLQueryItem *> *)queries {
    NSURLComponents *components = [NSURLComponents componentsWithString:eventBaseUrl];
    components.queryItems = queries;
    NSURL *url = components.URL;
    
    [[NSURLSession.sharedSession dataTaskWithURL:components.URL completionHandler:^(NSData * _Nullable data,
                                                                                    NSURLResponse * _Nullable response,
                                                                                    NSError * _Nullable error) {
        if (!error) {
            NSLog(@"EventTracker success loaded: %@", url.absoluteString);
        } else {
            NSLog(@"EventTracker failed: %@ with error: %@", url.absoluteString, error);
        }
    }] resume];
}

#pragma mark - Private

- (NSString *)eventString:(BMADMEvent)event {
    switch (event) {
        case BMADMEventBMRequestStart: return @"BMRequestStart";
        case BMADMEventBMRequestFail: return @"BMRequestFail";
        case BMADMEventBMRequestSuccess: return @"BMRequestSuccess";
        case BMADMEventGAMLoadStart: return @"GAMLoadStart";
        case BMADMEventGAMLoaded: return @"GAMLoaded";
        case BMADMEventGAMFailToLoad: return @"GAMFailToLoad";
        case BMADMEventGAMAppEvent: return @"GAMAppEvent";
        case BMADMEventGAMMetadata: return @"GAMMetadata";
        case BMADMEventBMLoadStart: return @"BMLoadStart";
        case BMADMEventBMLoaded: return @"BMLoaded";
        case BMADMEventBMClicked: return @"BMClicked";
        case BMADMEventBMFailToLoad: return @"BMFailToLoad";
        case BMADMEventBMIsLoaded: return @"BMIsLoaded";
        case BMADMEventBMShow: return @"BMShow";
        case BMADMEventBMClosed: return @"BMClosed";
        case BMADMEventBMReward: return @"BMReward";
        case BMADMEventBMShown: return @"BMShown";
        case BMADMEventBMFailToShow: return @"BMFailToShow";
        case BMADMEventBMExpired: return @"BMExpired";
        case BMADMEventBMBannerAPIShow: return @"BMBannerAPIShow";
        case BMADMEventBMBannerAPIHide: return @"BMBannerAPIHide";
    }
}

- (NSString *)eventAdTypeString:(BMADMEventType)type {
    switch (type) {
        case BMADMEventTypeBanner: return @"banner";
        case BMADMEventTypeRewarded: return @"rewarded";
        case BMADMEventTypeInterstitial: return @"interstitial";
    }
}

@end
