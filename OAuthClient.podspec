Pod::Spec.new do |s|
 
  s.name         = "OAuthClient"
  s.version      = "0.1.5"
  s.summary      = "OAuthClient."
  s.description  = <<-DESC
    OAuthClient
  DESC
  s.requires_arc = true
 
  s.homepage     = "https://github.com/darioalessandro/OAuthClientiOS"
  s.license      = { :type => "Apache2", :file => "License.txt" }
  s.author       = { "Dario Lencina" => "darioalessandrolencina@gmail.com" }
  s.social_media_url   = "https://twitter.com/darioalessandro"
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/darioalessandro/OAuthClientiOS.git", :tag => s.version }
  s.source_files  = "OAuthClientFramework/*"
  s.resources = ["OAuthClientFramework/Resources/*"]

 
end
