require 'rfm'
require 'net/http'
require 'open-uri'

class PdfReader

  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

  attr_reader :server, :record_id

  def initialize(db_config, record_id)
    @server = Rfm::Server.new(db_config)
    @record_id = record_id
  end

  def pdf_uri
    results_set = server['db']['DOCUMENTS (AUTO SAVE)'].find(record_id)
    results_set.first.pdf
  end

  def download(noblank = true)
    txt_array = []
    uri = URI('https://' + server.get_config[:host] + pdf_uri)
    req = Net::HTTP::Get.new(uri)
    req.basic_auth server.get_config[:account_name], server.get_config[:password]
    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      response = http.request(req)
      File.open('temp.pdf', 'wb') do |pdf_file|
        pdf_file.write(response.read_body)
        `pdftotext -enc UTF-8 temp.pdf`
        File.open('./temp.txt') do |text_file|
          text_file.readlines.each do |l|
          l.chomp! if noblank
            txt_array << l if l.length > 0
          end
          File.delete(text_file)
        end
        File.delete(pdf_file)
      end
      parse_app_refs(txt_array).join("\n")
    end
  end

  def parse_app_refs(arr)
    nasty_regex = '^(?:\d{1,2}. )?([A-Z]{1,3}\/20\d{2}\/\d{4})$'
    arr.map { |t| /#{nasty_regex}/.match(t)[1] rescue nil }.uniq.compact
  end

end
