//
//  BMADMAdEventProtocol.h
//  BidMachineAdMobAdManager
//
//  Created by Ilia Lozhkin on 5/18/20.
//  Copyright © 2020 Appodeal. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BMADMAdEventDelegate <NSObject>

- (void)onAdLoaded;

- (void)onAdFailToLoad;

- (void)onAdFailToPresent;

- (void)onAdShown;

- (void)onAdClicked;

- (void)onAdClosed;

- (void)onAdExpired;

@optional

- (void)onAdRewarded;

@end

@protocol BMADMAdEventProtocol <NSObject>

@property (nonatomic, weak) id<BMADMAdEventDelegate> delegate;

- (void)loadAd;

- (BOOL)isLoaded;

- (void)show:(UIViewController *)controller;

@end
