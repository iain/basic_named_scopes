require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "basic_named_scopes"
    gem.summary = %Q{Basic named scopes for ActiveRecord makes all find-parameters a named scope}
    gem.description = %Q{Make your queries prettier and more reusable by having a named scope for every find-parameter. As easy as Post.include(:author, :comments)}
    gem.email = "iain@iain.nl"
    gem.homepage = "http://github.com/iain/basic_named_scopes"
    gem.authors = ["Iain Hecker"]
    gem.add_development_dependency "rspec", ">= 1.2.9"
    gem.add_development_dependency "temping", ">= 1.3.0"
    gem.add_development_dependency "activerecord", "< 3.0.pre"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "basic_named_scopes #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
