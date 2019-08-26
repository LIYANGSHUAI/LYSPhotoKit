Pod::Spec.new do |s|
s.name         = "LYSPhotoKit"
s.version      = "0.0.3"
s.summary      = "简单封装一个图片选择器,支持单选和多选"
s.description  = <<-DESC
简单封装一个图片选择器,支持单选和多选.简单封装一个图片选择器,支持单选和多选
DESC
s.homepage     = "https://github.com/LIYANGSHUAI/LYSPhotoKit"

s.platform     = :ios, "8.0"
s.license      = "MIT"
s.author             = { "李阳帅" => "liyangshuai163@163.com" }

s.source       = { :git => "https://github.com/LIYANGSHUAI/LYSPhotoKit.git", :tag => s.version }

s.source_files  = "LYSPhotoKit", "LYSPhotoKit/*.{h,m}"
s.resource_bundles = {'LYSPhotoResource' => 'LYSPhotoKit/Resources/*.png'}
end
