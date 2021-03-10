//
//  BMADMBannerView.h
//  BidMachineAdMobAdManager
//
//  Created by Ilia Lozhkin on 5/18/20.
//  Copyright © 2020 Appodeal. All rights reserved.
//

#import <BidMachineAdMobAdManager/BMADMAdEventProtocol.h>


@interface BMADMBannerView : UIView <BMADMAdEventProtocol>

@property (nonatomic, weak) id<BMADMAdEventDelegate> delegate;

@property (nonatomic, strong) NSString *unitId;

@end
