# D = Steep::Diagnostic

target :app do
  signature "sig", "vendor/rbs"

  check "app/models/**/*.rb"
  check "lib"

  ignore "lib/resque_job.rb"
  ignore "lib/document_exporter/gdoc/base.rb"

  library "base64"
  library "activerecord"
  library "activesupport"
end
