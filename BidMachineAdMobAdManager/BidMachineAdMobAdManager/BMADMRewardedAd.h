//
//  BMADMRewardedAd.h
//  BidMachineAdMobAdManager
//
//  Created by Ilia Lozhkin on 25.05.2020.
//  Copyright © 2020 Appodeal. All rights reserved.
//

#import <BidMachineAdMobAdManager/BMADMAdEventProtocol.h>

@interface BMADMRewardedAd : NSObject <BMADMAdEventProtocol>

@property (nonatomic, weak) id<BMADMAdEventDelegate> delegate;

- (instancetype)initWithUnitId:(NSString *)unitId;

@end
