require 'openssl'

DB_CONFIG = {
  host: ENV['FMS_HOST'],
  account_name: ENV['FMS_ACCOUNT_NAME'],
  password: ENV['FMS_PASSWORD'],
  ssl: true,
  port: 443,
  root_cert_name: File.basename(OpenSSL::X509::DEFAULT_CERT_FILE),
  root_cert_path: File.dirname(OpenSSL::X509::DEFAULT_CERT_FILE)
}
