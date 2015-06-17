desc 'Run tests'
task :test do
  command = "xcodebuild \
    -workspace SoapKit.xcworkspace \
    -scheme SoapKit \
    -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 6,OS=8.1' \
    test \
    GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=YES \
    GCC_GENERATE_TEST_COVERAGE_FILES=YES"
  system(command) or exit 1
end
task :default => :test