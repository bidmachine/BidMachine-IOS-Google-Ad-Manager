
platform :ios, '10.0'

workspace 'BidMachineAdMobAdManager.xcworkspace'

install! 'cocoapods', :deterministic_uuids => false, :warn_for_multiple_pod_sources => false

source 'https://github.com/appodeal/CocoaPods.git'
source 'https://github.com/CocoaPods/Specs.git'

def bidmachine
  pod "BDMIABAdapter", "1.7.0.2.0-Beta"
end

def google
  pod 'Google-Mobile-Ads-SDK', '~> 8.1.0'
end

target 'BidMachineAdMobAdManager' do
  project 'BidMachineAdMobAdManager/BidMachineAdMobAdManager.xcodeproj'
  google
  bidmachine
end

target 'BidMachineAdMobAdManagerSample' do
  project 'BidMachineAdMobAdManagerSample/BidMachineAdMobAdManagerSample.xcodeproj'
  google
  bidmachine
end
