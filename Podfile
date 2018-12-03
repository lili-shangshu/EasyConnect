# Uncomment this line to define a global platform for your project
platform :ios, ‘8.0’

target ‘IosBasic’ do
    pod 'AFNetworking', '~> 2.5.0'
    pod 'MagicalRecord', '~> 2.2'
    pod 'PSAlertView', '~> 2.0.3'
    pod 'CTAssetsPickerController', '~> 2.9.2'
    pod 'NJKWebViewProgress', '~> 0.2.3'
#    pod 'JBWebViewController', '~> 1.0.6'
    pod 'DZNWebViewController', '~> 3.0'
    pod 'Reachability', '~> 3.2'
    pod 'YYModel', '~> 1.0.2'
    pod 'IQKeyboardManager', '~> 4.0.10'
    pod 'ARChromeActivity', '~> 1.0.6'
    pod 'ARSafariActivity', '~> 1.0.4'
    
end


post_install do |installer|
    copy_pods_resources_path = "Pods/Target Support Files/Pods-[IosBasic]/Pods-[IosBasic]-resources.sh"
    string_to_replace = '--compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"'
    assets_compile_with_app_icon_arguments = '--compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}" --app-icon "${ASSETCATALOG_COMPILER_APPICON_NAME}" --output-partial-info-plist "${BUILD_DIR}/assetcatalog_generated_info.plist"'
    text = File.read(copy_pods_resources_path)
    new_contents = text.gsub(string_to_replace, assets_compile_with_app_icon_arguments)
    File.open(copy_pods_resources_path, "w") {|file| file.puts new_contents }
end

target ‘IosBasicTests' do

end

