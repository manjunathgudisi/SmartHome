target 'mySmartHome' do

use_frameworks!

pod "SwiftChart"

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        puts "#{target.name}"
    end
end
