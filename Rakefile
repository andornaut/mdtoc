# typed: false
# frozen_string_literal: true

require "bundler"
require "rake/testtask"
require "rubocop/rake_task"

Bundler::GemHelper.install_tasks

desc "Run the build, rubocop:autocorrect_all, sorbet and test tasks"
task default: ["build", "rubocop:autocorrect_all", "sorbet", "test"]

RuboCop::RakeTask.new

Rake::TestTask.new(:test) do |t|
  t.libs << "lib"
  t.libs << "test"
  t.test_files = FileList["test/**/test_*.rb"]
end

desc "Run the Sorbet type checker"
task :sorbet do
  sh "srb tc"
end
