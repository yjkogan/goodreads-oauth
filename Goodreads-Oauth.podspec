Pod::Spec.new do |s|
  s.name         = "Goodreads-Oauth"
  s.version      = "1.0.0"
  s.summary      = "Library for making OAuth with Goodreads from iOS Easier."
  s.homepage     = "https://github.com/yjkogan/goodreads-oauth"

  s.license      = 'MIT'

  s.author       = { "Yonatan Kogan" => "yjkogan@gmail.com" }

  s.source       = { :git => "https://github.com/yjkogan/goodreads-oauth.git", :tag => "1.0.0" }

  s.platform     =  :ios, '6.0'

  s.source_files = 'Dependencies','Dependencies/**/*.{h,m}','GROAuth.{h,m}'

  s.public_header_files = 'GROAuth'

  s.requires_arc = true
end
