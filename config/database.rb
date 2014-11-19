require 'openssl'

if ENV['RACK_ENV'] == 'production'
  cert_file = '/usr/lib/ssl/certs/ca-certificates.crt' # Heroku
else
  cert_file = OpenSSL::X509::DEFAULT_CERT_FILE
end

DB_CONFIG = {
  host: ENV['FMS_HOST'],
  account_name: ENV['FMS_ACCOUNT_NAME'],
  password: ENV['FMS_PASSWORD'],
  ssl: true,
  port: 443,
  root_cert_name: File.basename(cert_file),
  root_cert_path: File.dirname(cert_file)
}
