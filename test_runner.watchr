require 'auto/colour_prompt'

PATH_TO_RAKE_EXE = 'C:\ruby\bin\rake.bat'
LIB_C_FILES      = 'lib/*.*\.c'
LIB_H_FILES      = 'lib/*.*\.h'
ALL_C_TEST_FILES = 'test/test*.*\.c'

files_to_test = [ALL_C_TEST_FILES, LIB_C_FILES, LIB_H_FILES]

def run_rake
  system ("#{PATH_TO_RAKE_EXE} --silent")
end

#   #   #   #   #   #   #   #   

files_to_test.each do |file_pattern|
  watch(file_pattern) do |md|
    colour_puts :narrative, "\ntest activated by #{md}..."
    run_rake
  end
end

