//
//  BMADMRewardedAd.m
//  BidMachineAdMobAdManager
//
//  Created by Ilia Lozhkin on 25.05.2020.
//  Copyright © 2020 Appodeal. All rights reserved.
//

#import "BMADMRewardedAd.h"
#import "BMADMNetworkEvent.h"
#import <BidMachine/BidMachine.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface BMADMRewardedAd()<BDMRewardedDelegate, BDMRequestDelegate, GADAdMetadataDelegate>

@property (nonatomic, strong) BDMRewarded *rewarded;
@property (nonatomic, strong) GADRewardedAd *adMobRewarded;
@property (nonatomic, strong) BDMRewardedRequest *rewardedRequest;
@property (nonatomic, strong) NSString *unitId;
@property (nonatomic, strong) BMADMNetworkEvent *event;
@property (nonatomic, strong) NSDictionary *customParams;

@end

@implementation BMADMRewardedAd

- (instancetype)initWithUnitId:(NSString *)unitId {
    if (self = [super init]) {
        _unitId = unitId;
    }
    return self;
}

- (void)loadAd {
    [self clean];
    self.event.request = self.rewardedRequest;
    [self.event trackEvent:BMADMEventBMRequestStart customParams:nil];
    [self.rewardedRequest performWithDelegate:self];
}

- (void)show:(UIViewController *)controller {
    [self.event trackEvent:BMADMEventBMShow customParams:self.customParams];
    [self.rewarded presentFromRootViewController:controller];
}

- (BOOL)isLoaded {
    return [self.rewarded isLoaded];
}

#pragma mark - Private

- (void)clean {
    self.rewarded = nil;
    self.adMobRewarded = nil;
    self.rewardedRequest = nil;
    self.event = nil;
    self.customParams = nil;
}

- (BDMRewardedRequest *)rewardedRequest {
    if (!_rewardedRequest) {
        _rewardedRequest = [BDMRewardedRequest new];
    }
    return _rewardedRequest;
}

- (BDMRewarded *)rewarded {
    if (!_rewarded) {
        _rewarded = [BDMRewarded new];
        _rewarded.delegate = self;
    }
    return _rewarded;
}

- (BMADMNetworkEvent *)event {
    if (!_event) {
        _event = BMADMNetworkEvent.new;
        _event.adType = BMADMEventTypeRewarded;
    }
    return _event;
}

#pragma mark - BDMRewardedDelegate

- (void)rewardedReadyToPresent:(nonnull BDMRewarded *)rewarded {
    [self.event trackEvent:BMADMEventBMLoaded customParams:self.customParams];
    [self.delegate onAdLoaded];
}

- (void)rewarded:(nonnull BDMRewarded *)rewarded failedWithError:(nonnull NSError *)error {
    [self.event trackError:error event:BMADMEventBMFailToLoad customParams:self.customParams internal:NO];
    [self.delegate onAdFailToLoad];
}

- (void)rewarded:(nonnull BDMRewarded *)rewarded failedToPresentWithError:(nonnull NSError *)error {
    [self.event trackError:error event:BMADMEventBMFailToShow customParams:self.customParams internal:NO];
    [self.delegate onAdFailToPresent];
}

- (void)rewardedWillPresent:(nonnull BDMRewarded *)rewarded {
    [self.event trackEvent:BMADMEventBMShown customParams:self.customParams];
    [self.delegate onAdShown];
}

- (void)rewardedDidDismiss:(nonnull BDMRewarded *)rewarded {
    [self.event trackEvent:BMADMEventBMClosed customParams:self.customParams];
    [self.delegate onAdClosed];
}

- (void)rewardedRecieveUserInteraction:(nonnull BDMRewarded *)rewarded {
    [self.event trackEvent:BMADMEventBMClicked customParams:self.customParams];
    [self.delegate onAdClicked];
}

- (void)rewardedFinishRewardAction:(nonnull BDMRewarded *)rewarded {
    [self.event trackEvent:BMADMEventBMReward customParams:self.customParams];
    [self.delegate onAdRewarded];
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
    
    [GADRewardedAd loadWithAdUnitID:self.unitId
                            request:adMobRequest
                  completionHandler:^(GADRewardedAd * _Nullable rewardedAd,
                                      NSError * _Nullable error) {
        if (error) {
            [self.event trackError:error event:BMADMEventGAMFailToLoad customParams:self.customParams internal:YES];
            [weakSelf.delegate onAdFailToLoad];
        } else {
            self.adMobRewarded = rewardedAd;
            self.adMobRewarded.adMetadataDelegate = self;
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

#pragma mark - GADAdMetadataDelegate

- (void)adMetadataDidChange:(nonnull id<GADAdMetadataProvider>)ad {
    [self.event trackEvent:BMADMEventGAMAppEvent customParams:self.customParams];
    if (![ad.adMetadata[@"AdTitle"] isEqual:@"bidmachine-rewarded"]) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:500 userInfo:nil];
        [self.event trackError:error event:BMADMEventGAMFailToLoad customParams:self.customParams internal:YES];
        [self.delegate onAdFailToLoad];
    } else {
        [self.event trackEvent:BMADMEventBMLoadStart customParams:self.customParams];
        [self.rewarded populateWithRequest:self.rewardedRequest];
    }
}

@end
