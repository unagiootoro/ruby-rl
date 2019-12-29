require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

task :doc do
  src_list = Dir["lib/rl.rb"]
  src_list += Dir["lib/rl/*.rb"]
  sh "yardoc #{src_list.join(' ')}"
end


task :default => :test
