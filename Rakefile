# typed: false
# frozen_string_literal: true

require 'bundler'
require 'rubocop/rake_task'

Bundler::GemHelper.install_tasks

desc 'Run all verification in containers'
task default: :check

RuboCop::RakeTask.new

desc 'Run the Sorbet type checker'
task :sorbet do
  sh 'srb tc'
end

Rake::Task[:build].clear

%w[check test lint build].each do |name|
  desc "Run #{name} in a container"
  task name do
    sh 'make', name
  end
end
