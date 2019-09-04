# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'
#plugin 'cocoapods-binary'
#all_binary!
use_frameworks!

def pods
	pod 'SwiftLint'
	pod 'Alamofire'
	pod 'LayoutKit'
	pod 'KeychainAccess'
	pod 'IQKeyboardManagerSwift'
	pod 'Kingfisher'
	pod 'NextGrowingTextView'
	pod 'Fabric'
	pod 'Crashlytics'
	pod 'Cache'
	pod 'lottie-ios'
	pod 'Kanna'
	pod 'Firebase/Core'
	pod 'Firebase/RemoteConfig'
	pod 'Texture'
end

target 'FSPO' do
	pods
end
target 'TodaySchedule' do
	pod 'Alamofire'
	pod 'LayoutKit'
	pod 'Cache'
end
post_install do |installer|
    #installer.pods_project.targets.each do |target|
    #    if target.name == 'Texture' then
    #        target.build_configurations.each do |configuration|
    #            if configuration.name.include?("Debug") then
    #                configuration.build_settings['ONLY_ACTIVE_ARCH'] = 'YES'
    #            end
    #        end
    #    end
    #end
    installer.pods_project.targets.each do |target|
            if target.name == 'LayoutKit'
                target.build_configurations.each do |config|
                    config.build_settings['SWIFT_VERSION'] = '4.0'
            end
        end
    end
end
