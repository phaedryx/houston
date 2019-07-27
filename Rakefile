# frozen_string_literal: true

require 'rake/testtask'

task default: 'test'

Rake::TestTask.new do |task|
  task.libs += ['test', 'lita/handlers']
  task.test_files = FileList['test/**/*_test.rb']
end
