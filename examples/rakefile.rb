$here = File.expand_path( File.dirname( __FILE__ ) )

require 'rake/clean'
require 'rake/loaders/makefile'
require 'fileutils'
require 'set'
require '../auto/unity_test_summary'
require '../auto/generate_test_runner'

#USE THIS ONE IF YOU WANT TO TRY THIS WITH GCC
require 'rakefile_helper_GCC'

#USE THIS ONE IF YOU WANT TO TRY THIS WITH IAR
#require 'rakefile_helper_IAR'

include RakefileHelpers

#This tells us where to clean our temporary files
CLEAN.include('build/*')

#This is what is run when you type rake with no params
desc "Build and run all tests, then output results (you can just type \"rake\" to get this)."
task :default => [:clobber, :all, :summary]

#This runs our test summary
task :summary do
  flush_output
  summary = UnityTestSummary.new
  summary.set_root_path($here)
  summary.set_targets(Dir[BUILD_PATH+'/*.test*'])
  summary.run
end

#This builds and runs all the unit tests
task :all do
  puts "Starting Test Suite"
  runner_generator = UnityTestRunnerGenerator.new
  test_sets = {}
  
  #compile unity files
  Dir[UNITY_PATH+'/*.c'].each do |file|
    compile(file, BUILD_PATH+'/'+File.basename(file).gsub('.c', OBJ_EXTENSION))
  end
  
  #compile source files
  Dir[SOURCE_PATH+'/*.c'].each do |file|
    compile(file, BUILD_PATH+'/'+File.basename(file).gsub('.c', OBJ_EXTENSION))
  end
  
  #compile test files
  Dir[UNIT_TEST_PATH+'/*.c'].each do |file|
    compile(file, BUILD_PATH+'/'+File.basename(file).gsub('.c', OBJ_EXTENSION))
  end
  
  #compile runner files
  Dir[UNIT_TEST_PATH+'/*.c'].each do |file|
    run_file = BUILD_PATH+'/'+File.basename(file).gsub('.c','_Runner.c')
    test_set = runner_generator.run(file, run_file)
    compile(run_file, run_file.gsub('.c', OBJ_EXTENSION))
    test_sets[run_file.gsub('_Runner.c', BIN_EXTENSION)] = test_set.map {|req_file| BUILD_PATH + '/' + File.basename(req_file).gsub(/\.[c|h]/, OBJ_EXTENSION)}
  end
  
  #link and run each test
  test_sets.each_pair do |exe_file, obj_files|
    link(obj_files, exe_file)
    write_result_file(exe_file, run_test(exe_file))
  end
end

