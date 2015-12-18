require "bundler/gem_tasks"
require 'rake/testtask'

namespace :test do
  adapters = [ :postgresql ]
  task :all => [ :procedural ] + adapters

  adapters.each do |adapter|
    Rake::TestTask.new(adapter) do |t|
      t.libs.push "lib"
      t.libs.push "spec"
      t.pattern = "spec/adapters/#{t.name}*_spec.rb"
      t.verbose = true
    end
  end

  Rake::TestTask.new(:procedural) do |t|
    t.libs.push "lib"
    t.libs.push "spec"
    t.pattern = "spec/procedural/**/*_spec.rb"
    t.verbose = true
  end
end

task :default => 'test:all'
