//
//  BMADMInterstitial.h
//  BidMachineAdMobAdManager
//
//  Created by Ilia Lozhkin on 5/15/20.
//  Copyright © 2020 Appodeal. All rights reserved.
//

#import <BidMachineAdMobAdManager/BMADMAdEventProtocol.h>


@interface BMADMInterstitial : NSObject <BMADMAdEventProtocol>

@property (nonatomic, weak) id<BMADMAdEventDelegate> delegate;

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithUnitId:(NSString *)unitId rewarded:(BOOL)rewarded NS_DESIGNATED_INITIALIZER;

@end
