# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
platform :ios, '10.0'
source 'https://github.com/CocoaPods/Specs.git'

target 'cooking_app' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'Alamofire', '~> 4.5'


  # Pods for cooking_app

end

post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
               end
          end
   end
end
