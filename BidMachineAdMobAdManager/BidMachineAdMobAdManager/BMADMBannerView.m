//
//  BMADMBannerView.m
//  BidMachineAdMobAdManager
//
//  Created by Ilia Lozhkin on 5/18/20.
//  Copyright © 2020 Appodeal. All rights reserved.
//

#import "BMADMBannerView.h"
#import "BMADMNetworkEvent.h"
#import <BidMachine/BidMachine.h>
#import <StackUIKit/StackUIKit.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface BMADMBannerView ()<BDMBannerDelegate, BDMRequestDelegate, GADBannerViewDelegate, GADAppEventDelegate, BDMAdEventProducerDelegate>

@property (nonatomic, strong) BDMBannerView *banner;
@property (nonatomic, strong) GAMBannerView *adMobBanner;
@property (nonatomic, strong) BDMBannerRequest *bannerRequest;
@property (nonatomic, strong) BMADMNetworkEvent *event;
@property (nonatomic, strong) NSDictionary *customParams;

@end

@implementation BMADMBannerView

- (void)loadAd {
    [self clean];
    self.event.request = self.bannerRequest;
    [self.event trackEvent:BMADMEventBMRequestStart customParams:nil];
    [self.bannerRequest performWithDelegate:self];
}

- (void)show:(UIViewController *)controller {
    if (!self.banner.superview) {
        [self.event trackEvent:BMADMEventBMShow customParams:self.customParams];
        self.banner.rootViewController = controller;
        [self.banner stk_edgesEqual:self];
    }
}

- (BOOL)isLoaded {
    return [self.banner isLoaded];
}

#pragma mark - Private

- (void)clean {
    self.banner = nil;
    self.adMobBanner = nil;
    self.bannerRequest = nil;
    self.event = nil;
    self.customParams = nil;
}

- (BDMBannerRequest *)bannerRequest {
    if (!_bannerRequest) {
        _bannerRequest = [BDMBannerRequest new];
    }
    return _bannerRequest;
}

- (BDMBannerView *)banner {
    if (!_banner) {
        _banner = [BDMBannerView new];
        _banner.delegate = self;
        _banner.producerDelegate = self;
    }
    return _banner;
}

- (GAMBannerView *)adMobBanner {
    if (!_adMobBanner) {
        _adMobBanner = [[GAMBannerView alloc] initWithAdSize:kGADAdSizeBanner];
        _adMobBanner.delegate = self;
        _adMobBanner.adUnitID = self.unitId;
        _adMobBanner.rootViewController = [[UIApplication.sharedApplication keyWindow] rootViewController];
        _adMobBanner.appEventDelegate = self;
    }
    return _adMobBanner;
}

- (BMADMNetworkEvent *)event {
    if (!_event) {
        _event = BMADMNetworkEvent.new;
        _event.adType = BMADMEventTypeBanner;
    }
    return _event;
}

#pragma mark - BDMBannerDelegate

- (void)bannerViewReadyToPresent:(nonnull BDMBannerView *)bannerView {
    [self.event trackEvent:BMADMEventBMLoaded customParams:self.customParams];
    [self.delegate onAdLoaded];
}

- (void)bannerView:(nonnull BDMBannerView *)bannerView failedWithError:(nonnull NSError *)error {
    [self.event trackError:error event:BMADMEventBMFailToLoad customParams:self.customParams internal:NO];
    [self.delegate onAdFailToLoad];
}

- (void)bannerViewRecieveUserInteraction:(nonnull BDMBannerView *)bannerView {
    [self.event trackEvent:BMADMEventBMClicked customParams:self.customParams];
    [self.delegate onAdClicked];
}

- (void)bannerViewDidExpire:(nonnull BDMBannerView *)bannerView {
    [self.event trackEvent:BMADMEventBMExpired customParams:self.customParams];
    [self.delegate onAdExpired];
}

- (void)bannerViewWillPresentScreen:(nonnull BDMBannerView *)bannerView {

}

- (void)bannerViewDidDismissScreen:(nonnull BDMBannerView *)bannerView {

}

- (void)didProduceImpression:(nonnull id<BDMAdEventProducer>)producer {
    [self.event trackEvent:BMADMEventBMShown customParams:self.customParams];
    [self.delegate onAdShown];
}

- (void)didProduceUserAction:(nonnull id<BDMAdEventProducer>)producer {
    
}

#pragma mark - BDMRequestDelegate

- (void)request:(nonnull BDMRequest *)request failedWithError:(nonnull NSError *)error {
    [self.event trackError:error event:BMADMEventBMRequestFail customParams:nil internal:NO];
    [self.delegate onAdFailToLoad];
}

- (void)request:(nonnull BDMRequest *)request completeWithInfo:(nonnull BDMAuctionInfo *)info {
    [request notifyMediationWin];
    self.customParams = request.info.customParams;
    
    NSMutableDictionary *params = request.info.customParams.mutableCopy;
    params[@"bm_pf"] = @"1000.0";
    self.customParams = params;
    
    GAMRequest *adMobRequest = [GAMRequest request];
    adMobRequest.customTargeting = self.customParams;
    
    [self.event trackEvent:BMADMEventBMRequestSuccess customParams:self.customParams];
    [self.event trackEvent:BMADMEventGAMLoadStart customParams:self.customParams];
    [self.adMobBanner loadRequest:adMobRequest];
}

- (void)requestDidExpire:(nonnull BDMRequest *)request {
    [self.event trackEvent:BMADMEventBMExpired customParams:self.customParams];
    [self.delegate onAdExpired];
}

#pragma mark - GADBannerViewDelegate

- (void)bannerViewDidReceiveAd:(nonnull GADBannerView *)bannerView {
    [self.event trackEvent:BMADMEventGAMLoaded customParams:self.customParams];
}

- (void)bannerView:(nonnull GADBannerView *)bannerView
didFailToReceiveAdWithError:(nonnull NSError *)error {
    [self.event trackError:error event:BMADMEventGAMFailToLoad customParams:self.customParams internal:YES];
    [self.delegate onAdFailToLoad];
}

- (void)bannerViewDidRecordImpression:(nonnull GADBannerView *)bannerView {
    
}

- (void)adView:(nonnull GADBannerView *)banner
didReceiveAppEvent:(nonnull NSString *)name
      withInfo:(nullable NSString *)info {
    NSMutableDictionary *customInfo = self.customParams.mutableCopy;
    customInfo[@"app_event_key"] = name;
    customInfo[@"app_event_value"] = info;
    
    if ([name isEqualToString:@"bidmachine-banner"]) {
        [self.event trackEvent:BMADMEventGAMAppEvent customParams:customInfo];
        [self.event trackEvent:BMADMEventBMLoadStart customParams:self.customParams];
        [self.banner populateWithRequest:self.bannerRequest];
    } else {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:500 userInfo:nil];
        [self.event trackError:error event:BMADMEventGAMFailToLoad customParams:customInfo internal:YES];
        [self.delegate onAdFailToLoad];
    }
}

@end
