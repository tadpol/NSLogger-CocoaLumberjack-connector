Pod::Spec.new do |s|
  s.name     = 'NSLogger-CocoaLumberjack-connector'
  s.version  = '1.2.3'
  s.license  = 'BSD'
  s.summary  = 'Bridges NSLogger and CocoaLumberjack.'
  s.homepage = 'https://github.com/tadpol/NSLogger-CocoaLumberjack-connector'
  s.authors   = { 'Peter Steinberger' => 'steipete@gmail.com',
				  'Michael Conrad Tadpol Tilstra' => 'tadpol@tadpol.org'}
  s.source   = { :git => 'https://github.com/tadpol/NSLogger-CocoaLumberjack-connector.git',
				 :tag => '1.2.3' }
  s.description = <<-DESC
	This is a bridge for the projects http://github.com/robbiehanson/CocoaLumberjack
	(A general purpose super-fast logging framework) and http://github.com/fpillet/NSLogger
	(send logs to a client app via network).
	DESC
  s.platform = :ios, '7.0'
  s.requires_arc = true
  s.source_files = 'DDNSLoggerLogger.*'
  s.dependency 'NSLogger'
  s.dependency 'CocoaLumberjack'
end
#  vim: set ai et sw=2 ts=2 ft=ruby :
