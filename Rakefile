begin
  require 'rubygems'
rescue LoadError
  # nothing
end
require 'spec/rake/spectask'
require 'spec/rake/verify_rcov'

task :default => :spec

Spec::Rake::SpecTask.new do |t|
  t.warning = true
  t.libs << 'lib'
  t.spec_files = FileList['spec/*.rb']
  t.spec_opts = ['--colour']
end

