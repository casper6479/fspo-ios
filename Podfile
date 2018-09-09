# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'
use_frameworks!

def pods
	pod 'SwiftLint'
	pod 'Alamofire'
	pod 'LayoutKit'
	pod 'KeychainAccess'
	pod 'IQKeyboardManagerSwift'
	pod 'Kingfisher'
	pod 'NextGrowingTextView'
	pod 'Fabric', '~> 1.7.9'
	pod 'Crashlytics', '~> 3.10.5'
	pod 'Cache'
	pod 'lottie-ios'
	pod 'Kanna'
	pod 'Firebase/Core'
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
    podsTargets = installer.pods_project.targets.find_all { |target| target.name.start_with?('Pods') }
    podsTargets.each do |target|
        target.frameworks_build_phase.clear
    end
end