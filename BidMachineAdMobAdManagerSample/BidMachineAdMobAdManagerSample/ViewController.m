//
//  ViewController.m
//  AdMobManagerBidMachineSample
//
//  Created by Ilia Lozhkin on 5/15/20.
//  Copyright © 2020 Appodeal. All rights reserved.
//

#import "ViewController.h"
#import <BidMachineAdMobAdManager/BidMachineAdMobAdManager.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface ViewController ()<BMADMAdEventDelegate>

@property (nonatomic, strong) BMADMInterstitial *interstitial;
@property (nonatomic, strong) BMADMBanner *banner;
@property (nonatomic, strong) BMADMInterstitial *rewarded;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    GADMobileAds.sharedInstance.requestConfiguration.testDeviceIdentifiers = @[ kGADSimulatorID ];
    
}

- (BMADMBanner *)banner {
    if (!_banner) {
        _banner = [[BMADMBanner alloc] initWithUnitId:@"/91759738/spacetour_banner_1"];
        _banner.delegate = self;
    }
    return _banner;
}

- (BMADMInterstitial *)interstitial {
    if (!_interstitial) {
        _interstitial = [[BMADMInterstitial alloc] initWithUnitId:@"/91759738/spacetour_interstitial_1" rewarded:NO];
        _interstitial.delegate = self;
    }
    return _interstitial;
}

- (BMADMInterstitial *)rewarded {
    if (!_rewarded) {
        _rewarded = [[BMADMInterstitial alloc] initWithUnitId:@"/91759738/spacetour_rewarded_1" rewarded:YES];
        _rewarded.delegate = self;
    }
    return _rewarded;
}

- (IBAction)bannerAction:(id)sender {
    [self.banner loadAd];
    [self.banner show:self];
}

- (IBAction)interstitialAction:(id)sender {
    [self.interstitial loadAd];
}

- (IBAction)rewardedAction:(id)sender {
    [self.rewarded loadAd];
}

- (IBAction)showBanner:(id)sender {
    [self.banner show:self];
}

- (IBAction)hideBanner:(id)sender {
    [self.banner hide];
}

#pragma mark - BMADMAdEventDelegate



- (void)onAdClicked {
    NSLog(@"[Callback] - click");
}

- (void)onAdClosed {
     NSLog(@"[Callback] - close");
}

- (void)onAdExpired {
     NSLog(@"[Callback] - expired");
}

- (void)onAdFailToLoad {
     NSLog(@"[Callback] - fail load");
}

- (void)onAdFailToPresent {
     NSLog(@"[Callback] - fail present");
}

- (void)onAdLoaded {
    NSLog(@"[Callback] - ad load");
    if ([self.banner isLoaded]) {
//        [self.banner show:self];
    }
    if ([self.interstitial isLoaded]) {
        [self.interstitial show:self];
    }
    if ([self.rewarded isLoaded]) {
        [self.rewarded show:self];
    }
}

- (void)onAdShown {
     NSLog(@"[Callback] - on shown");
}

@end
