version = "2.0.0"

Pod::Spec.new do |s|
  s.name         = "UICollectionViewLeftAlignedLayout"
  s.version      = version
  s.summary      = "A layout for UICollectionView that aligns the cells to the left or top"
  s.description  = <<-DESC
                   A `UICollectionViewLayout` implementation that aligns the cells to the left or top.

                   It uses `UICollectionViewFlowLayout` under the hood.
                   DESC
  s.homepage     = "https://github.com/mokagio/UICollectionViewLeftAlignedLayout"
  s.screenshots  = "https://raw.githubusercontent.com/coeur/UICollectionViewLeftAlignedLayout/master/screenshot.png"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.authors      = { "Giovanni Lodi" => "giovanni.lodi42@gmail.com", "Antoine Cœur" => "" }
  s.social_media_url   = "http://twitter.com/adigitalknight"
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/coeur/UICollectionViewLeftAlignedLayout.git", :tag => version }
  s.source_files  = "UICollectionViewLeftAlignedLayout/*.swift"
end
