Pod::Spec.new do |s|
s.name             = 'CodableHero'
s.version          = '1.0.0'
s.summary          = 'Save and Load your models'
s.description      = <<-DESC
Save and Load your models to Json
DESC
s.homepage         = 'https://github.com/velvetroom/codablehero'
s.license          = { :type => "MIT", :file => "LICENSE" }
s.author           = { 'iturbide' => 'codablehero@iturbi.de' }
s.platform         = :ios, '9.0'
s.source           = { :git => 'https://github.com/velvetroom/codablehero.git', :tag => "v#{s.version}" }
s.source_files     = 'Source/*.swift'
s.swift_version    = '4.2'
end
