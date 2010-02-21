HERE = File.expand_path(File.dirname(__FILE__)) + '/'

#require HERE + 'config/environment'
require 'rake'
require 'rake/clean'
require 'rake/testtask'
require 'rakefile_helper'

include RakefileHelpers

# Load default configuration, for now
DEFAULT_CONFIG_FILE = 'gcc.yml'
configure_toolchain(DEFAULT_CONFIG_FILE)

task :unit do
  run_tests get_unit_test_files
end

desc "Generate test summary"
task :summary do
  report_summary
end

desc "Run all tests (overrides test_file_filter)"
task :all_unit_tests do
  run_tests get_unit_test_files(:all)
end

desc "Build and test Unity"
task :all => [:clean, :unit, :summary]
task :default => [:clobber, :all]
task :ci => [:all_unit_tests]
task :cruise => [:all_unit_tests]

desc "Load configuration"
task :config, :config_file do |t, args|
  configure_toolchain(args[:config_file])
end
