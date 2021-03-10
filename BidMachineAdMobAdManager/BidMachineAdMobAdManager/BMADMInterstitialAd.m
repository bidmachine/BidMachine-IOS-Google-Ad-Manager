//
//  BMADMInterstitialAd.m
//  BidMachineAdMobAdManager
//
//  Created by Ilia Lozhkin on 25.05.2020.
//  Copyright © 2020 Appodeal. All rights reserved.
//

#import "BMADMInterstitialAd.h"
#import "BMADMNetworkEvent.h"
#import <BidMachine/BidMachine.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface BMADMInterstitialAd()<BDMInterstitialDelegate, BDMRequestDelegate, GADAppEventDelegate>

@property (nonatomic, strong) BDMInterstitial *interstitial;
@property (nonatomic, strong) GAMInterstitialAd *adMobInterstitial;
@property (nonatomic, strong) BDMInterstitialRequest *interstitialRequest;
@property (nonatomic, strong) NSString *unitId;
@property (nonatomic, strong) BMADMNetworkEvent *event;
@property (nonatomic, strong) NSDictionary *customParams;

@end

@implementation BMADMInterstitialAd

- (instancetype)initWithUnitId:(NSString *)unitId {
    if (self = [super init]) {
        _unitId = unitId;
    }
    return self;
}

- (void)loadAd {
    [self clean];
    self.event.request = self.interstitialRequest;
    [self.event trackEvent:BMADMEventBMRequestStart customParams:nil];
    [self.interstitialRequest performWithDelegate:self];
}

- (void)show:(UIViewController *)controller {
    [self.event trackEvent:BMADMEventBMShow customParams:self.customParams];
    [self.interstitial presentFromRootViewController:controller];
}

- (BOOL)isLoaded {
    return [self.interstitial isLoaded];
}

#pragma mark - Private

- (void)clean {
    self.interstitial = nil;
    self.adMobInterstitial = nil;
    self.interstitialRequest = nil;
    self.event = nil;
    self.customParams = nil;
}

- (BDMInterstitialRequest *)interstitialRequest {
    if (!_interstitialRequest) {
        _interstitialRequest = [BDMInterstitialRequest new];
    }
    return _interstitialRequest;
}

- (BDMInterstitial *)interstitial {
    if (!_interstitial) {
        _interstitial = [BDMInterstitial new];
        _interstitial.delegate = self;
    }
    return _interstitial;
}

- (BMADMNetworkEvent *)event {
    if (!_event) {
        _event = BMADMNetworkEvent.new;
        _event.adType = BMADMEventTypeInterstitial;
    }
    return _event;
}

#pragma mark - BDMInterstitialDelegate

- (void)interstitial:(nonnull BDMInterstitial *)interstitial failedToPresentWithError:(nonnull NSError *)error {
    [self.event trackError:error event:BMADMEventBMFailToShow customParams:self.customParams internal:NO];
    [self.delegate onAdFailToPresent];
}

- (void)interstitial:(nonnull BDMInterstitial *)interstitial failedWithError:(nonnull NSError *)error {
    [self.event trackError:error event:BMADMEventBMFailToLoad customParams:self.customParams internal:NO];
    [self.delegate onAdFailToLoad];
}

- (void)interstitialDidDismiss:(nonnull BDMInterstitial *)interstitial {
    [self.event trackEvent:BMADMEventBMClosed customParams:self.customParams];
    [self.delegate onAdClosed];
}

- (void)interstitialReadyToPresent:(nonnull BDMInterstitial *)interstitial {
    [self.event trackEvent:BMADMEventBMLoaded customParams:self.customParams];
    [self.delegate onAdLoaded];
}

- (void)interstitialRecieveUserInteraction:(nonnull BDMInterstitial *)interstitial {
    [self.event trackEvent:BMADMEventBMClicked customParams:self.customParams];
    [self.delegate onAdClicked];
}

- (void)interstitialWillPresent:(nonnull BDMInterstitial *)interstitial {
    [self.event trackEvent:BMADMEventBMShown customParams:self.customParams];
    [self.delegate onAdShown];
}

- (void)interstitialDidExpire:(nonnull BDMInterstitial *)interstitial {
    [self.event trackEvent:BMADMEventBMExpired customParams:self.customParams];
    [self.delegate onAdExpired];
}

#pragma mark - BDMRequestDelegate

- (void)request:(nonnull BDMRequest *)request completeWithInfo:(nonnull BDMAuctionInfo *)info {
    [request notifyMediationWin];
    self.customParams = request.info.customParams;
    
    __weak __typeof__(self) weakSelf = self;
    GAMRequest *adMobRequest = [GAMRequest request];
    adMobRequest.customTargeting = self.customParams;
    
    [self.event trackEvent:BMADMEventBMRequestSuccess customParams:self.customParams];
    [self.event trackEvent:BMADMEventGAMLoadStart customParams:self.customParams];
    
    [GAMInterstitialAd loadWithAdManagerAdUnitID:self.unitId
                                         request:adMobRequest
                               completionHandler:^(GAMInterstitialAd * _Nullable interstitialAd,
                                                   NSError * _Nullable error) {
        if (error) {
            [self.event trackError:error event:BMADMEventGAMFailToLoad customParams:self.customParams internal:YES];
            [weakSelf.delegate onAdFailToLoad];
        } else {
            self.adMobInterstitial = interstitialAd;
            self.adMobInterstitial.appEventDelegate = self;
            [self.event trackEvent:BMADMEventGAMLoaded customParams:self.customParams];
        }
    }];
}

- (void)request:(nonnull BDMRequest *)request failedWithError:(nonnull NSError *)error {
    [self.event trackError:error event:BMADMEventBMRequestFail customParams:nil internal:NO];
    [self.delegate onAdFailToLoad];
}

- (void)requestDidExpire:(nonnull BDMRequest *)request {
    [self.event trackEvent:BMADMEventBMExpired customParams:self.customParams];
    [self.delegate onAdExpired];
}

#pragma mark - GADAppEventDelegate

- (void)interstitialAd:(nonnull GADInterstitialAd *)interstitialAd
    didReceiveAppEvent:(nonnull NSString *)name
              withInfo:(nullable NSString *)info {
    NSMutableDictionary *customInfo = self.customParams.mutableCopy;
    customInfo[@"app_event_key"] = name;
    customInfo[@"app_event_value"] = info;
    
    if ([name isEqualToString:@"bidmachine-interstitial"]) {
        [self.event trackEvent:BMADMEventGAMAppEvent customParams:customInfo];
        [self.event trackEvent:BMADMEventBMLoadStart customParams:self.customParams];
        [self.interstitial populateWithRequest:self.interstitialRequest];
    } else {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:500 userInfo:nil];
        [self.event trackError:error event:BMADMEventGAMFailToLoad customParams:customInfo internal:YES];
        [self.delegate onAdFailToLoad];
    }
}

@end
