![BidMachine iOS](https://appodeal-ios.s3-us-west-1.amazonaws.com/docs/bidmachine.png)

# BidMachine IOS Google Ad Manager

- [Getting Started](#user-content-getting-started)
- [Initialize sdk](#user-content-initialize-sdk)
- [Banner implementation](#user-content-banner-implementation)
- [Interstitial implementation](#user-content-interstitial-implementation)
- [Rewarded implementation](#user-content-rewarded-implementation)


## Getting Started

##### Add following lines into your project Podfile

> **_NOTE:_** Spec contains a private pod for the BDM sdk. Add these lines to use the library

```ruby
source 'https://github.com/appodeal/CocoaPods.git'
source 'https://github.com/CocoaPods/Specs.git'
```

```ruby
source 'https://github.com/appodeal/CocoaPods.git'
source 'https://github.com/CocoaPods/Specs.git'

target 'Target' do
   project 'Project.xcodeproj'
  pod 'BidMachineAdMobAdManager', '~> 0.1.0'
end
```

### Initialize sdk

Use your seller id to initialize

``` objc
    NSString *sellerId = @"127";
    [BMADMManager initialize:sellerId];
```

### Banner implementation

> **_NOTE:_** Banners are automatically updated every 15 seconds. Banner display is anchored to the bottom edge of the controller

Create banner with google unit id

```objc

    self.banner = [[BMADMBanner alloc] initWithUnitId:@"/91759738/spacetour_banner_1"];
    self.banner.delegate = self;

```

Start uploading your banner

```objc

    [self.banner loadAd];
    // Automatically show banner after loading
    [self.banner show:self];
```

You can manage the display through

```objc

    [self.banner show:self];
    // or hide
    [self.banner hide];

```

### Interstitial implementation

Create interstitial with google unit id

```objc

    self.interstitial = [[BMADMInterstitial alloc] initWithUnitId:@"/91759738/spacetour_interstitial_1" rewarded:NO];
    self.interstitial.delegate = self;

```

Start uploading your interstitial

```objc

    [self.interstitial loadAd];
```

You can manage the display through

```objc

    if ([self.interstitial isLoaded]) {
        [self.interstitial show:self];
    }

```

### Rewarded implementation

Create rewarded ad with google unit id

```objc

    self.rewarded = [[BMADMInterstitial alloc] initWithUnitId:@"/91759738/spacetour_rewarded_1" rewarded:YES];
    self.rewarded.delegate = self;

```

Start uploading your rewarded ad

```objc

    [self.rewarded loadAd];
```

You can manage the display through

```objc

    if ([self.rewarded isLoaded]) {
        [self.rewarded show:self];
    }

```

