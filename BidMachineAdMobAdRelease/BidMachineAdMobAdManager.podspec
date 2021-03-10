Pod::Spec.new do |spec|
  spec.name         = "BidMachineAdMobAdManager"
  spec.version      = "0.0.9"
  spec.summary      = "BidMachine IOS SDK for GAM mediation"
  spec.description  = <<-DESC
  Supported ad formats: Banner, Interstitial, Rewarded Video.\n
                   DESC
  spec.homepage     = "https://github.com/bidmachine/BidMachine-Google-Mobile-Ads-iOS-Adapters"
  spec.license      = { :type => 'Apache License, Version 2.0', :text => <<-LICENSE
  Copyright 2019 Appodeal, Inc.
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
    LICENSE
}
  spec.author       = { "Appodeal" => "http://www.appodeal.com" }
  spec.platform     = :ios, '10.0'
  spec.source       = { :http => "https://appodeal-ios.s3-us-west-1.amazonaws.com/external-sdks/BidMachineAdMobAdManager/#{spec.version}/BidMachineAdMobAdManager.framework.zip" }

  spec.pod_target_xcconfig      = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64 arm64e armv7 armv7s', 'EXCLUDED_ARCHS[sdk=iphoneos*]' => 'i386 x86_64' }
  spec.user_target_xcconfig     = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64 arm64e armv7 armv7s', 'EXCLUDED_ARCHS[sdk=iphoneos*]' => 'i386 x86_64' }
  
  spec.vendored_frameworks = 'BidMachineAdMobAdManager.framework'
  spec.dependency 'BidMachine', '~> 1.7.0.0'
  spec.dependency 'Google-Mobile-Ads-SDK', '~> 7.69.0'
end