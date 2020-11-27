unless Rails.env.production?
  require 'rspec/core/rake_task'
  require 'coveralls/rake/task'
  Coveralls::RakeTask.new
  namespace :ci do
    desc 'Run all tests and generate coverage report'
    task report: [:spec, 'coveralls:push']
  end
end