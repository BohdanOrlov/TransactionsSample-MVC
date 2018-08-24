platform :ios, '11.0'
use_frameworks!

def common_pods
  pod 'Moya', '~> 11.0'
  pod 'RealmSwift'
  pod 'SwiftDate', '~> 5.0'
  pod 'DZNEmptyDataSet'
  pod 'ScrollableGraphView'
end

target 'LootInterview' do

  common_pods
  
  target 'LootInterviewTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'LootInterviewUITests' do
    inherit! :search_paths
    # Pods for testing
  end
end

