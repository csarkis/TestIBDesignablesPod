Pod::Spec.new do |s|
    s.name             = 'GraphicLibrary'
    s.version          = '0.0.1'
    s.summary          = 'Test pod for IBDesignables inside a pod'
    s.license          = { :type => 'MIT' }

    s.description      = 'Test pod for IBDesignables inside a pod'

    s.homepage         = 'https://github.com/csarkis/TestIBDesignablesPod.git'
    s.author           = 'csarkis'
    s.source           = { :git => 'https://github.com/csarkis/TestIBDesignablesPod.git', :tag => s.version.to_s }

    s.ios.deployment_target = '11.0'
    s.swift_version = '5.1'

    s.source_files = 'GraphicLibrary/**/*.swift'

end
