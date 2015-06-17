Pod::Spec.new do |s|
	s.name					= 'SoapKit'
	s.version				= '0.0.1'
	s.summary				= 'SoapKit is a framework to simplify the consumption of SOAP services'
	s.homepage				= 'https://github.com/hons82/SoapKit'
	s.license				= { :type => 'MIT', :file => 'LICENSE.md' }
	s.author				= { 'Hannes Tribus' => 'hons82@gmail.com' }
	s.source				= { :git => 'https://github.com/hons82/SoapKit.git', :tag => "v#{s.version}" }
	s.platform				= :ios, '7.1'
	s.requires_arc			= true
	s.library				= 'xml2'
	s.xcconfig				= { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2' }
	s.default_subspec		= 'Core'
	s.header_mappings_dir	= 'SoapKit'

	s.subspec 'Core' do |c|
		c.source_files			= 'SoapKit/*.{h,m}', 'SoapKit/Soap/**/*.{h,m}', 'SoapKit/Util/**/*.{h,m}'
		c.prefix_header_file	= "SoapKit/SoapKit-Prefix.pch"
		c.dependency			'ISO8601DateFormatter', '~> 0.7'
	end
	s.subspec 'Mapping' do |h|
		h.source_files			= 'SoapKit/Mapping/**/*.{h,m}'
		h.dependency			'SoapKit/Core'
	end
end