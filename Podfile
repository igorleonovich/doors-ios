platform :ios, '13.0'
use_frameworks!
#inhibit_all_warnings!

def pods
  pod 'MBProgressHUD'
  pod 'JWTDecode'
  pod 'SnapKit'
  pod 'Zip'
end

target 'Doors-iOS-Uni' do
  pods
end

target 'Doors-iOS-Extra' do
  pods
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = "13.0"
     end
  end
end
