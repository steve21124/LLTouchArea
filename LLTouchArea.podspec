Pod::Spec.new do |s|
  s.name = 'LLTouchArea'
  s.version = '0.0.1' # 1
  s.summary = 'LLTouchArea' # 2
  s.source = { :git => 'git://github.com/steve21124/LLTouchArea.git' } # 4
  s.source_files = 'LLTouchArea.{h,m}' # 5
  s.xcconfig = { 'LIBRARY_SEARCH_PATHS' => '"$(PODS_ROOT)/LLTouchArea"' }
  s.requires_arc = false
end