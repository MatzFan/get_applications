# require 'uri'
# require 'shellwords'
require 'rfm'
require 'net/http'
require 'open-uri'

class PdfReader

  CONN = Rfm::Server.new(
    host: 'n33.fmphost.com',
    account_name: 'admin',
    password: 'N0gbad01',
    ssl: true,
    port: 443
  )
  SCHEME = 'https://'
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

  # attr_reader :remote_url, :pdf_path, :bash_escaped_pdf_file_name

  def initialize
    # @remote_url = remote_url
    # @pdf_path = pdf_path
    # @bash_escaped_pdf_file_name = bash_escaped_pdf_file_name
  end

  def pdf_uri
    docs = CONN['db']['DOCUMENTS (AUTO SAVE)']
    results_set = docs.find(id: 64)
    record = results_set.first
    record.pdf
  # File.basename(URI.parse(remote_url).path)
  end

  def download(noblank = true)
    txt_array = []
    uri = URI(SCHEME + CONN.get_config[:host] + pdf_uri)
    req = Net::HTTP::Get.new(uri)
    req.basic_auth 'admin', 'N0gbad01'
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

  # def bash_escaped_pdf_file_name
  #   Shellwords.escape(URI.decode(encoded_pdf_file_name))
  # end

  # def pdf_path
  #   path = File.expand_path File.dirname(__FILE__) + '/' + encoded_pdf_file_name
  #   URI.decode(path)
  # end

  # def pdf_to_text(noblank = true)
  #   cmd = "pdftotext -enc UTF-8 '#{pdf_path}'"
  #   `#{cmd}`
  #   file = File.new(pdf_path.sub(/.pdf$/, '.txt'))
  #   txt_array = []
  #   file.readlines.each do |l|
  #     l.chomp! if noblank
  #     txt_array << l if l.length > 0
  #   end
  #   file.close
  #   txt_array
  # end

  # def download
  #   cmd = "curl #{remote_url} -o #{bash_escaped_pdf_file_name}"
  #   `#{cmd}`
  #   sleep(5)
  # end

  def parse_app_refs(txt_array)
    # txt_array = pdf_to_text
    txt_array.select { |t| t =~ /^[A-Z]{1,3}\/20\d{2}\/\d{4}$/ rescue nil }.uniq
  end

end

# pdf = 'http://www.gov.je/SiteCollectionDocuments/Planning%20and%20building/A%20PAP%2028%2008%202014.pdf'
# reader = PdfReader.new(pdf)
# puts reader.pdf_path
# puts reader.bash_escaped_pdf_file_name
# file = reader.download
# text = reader.pdf_to_text(file)
# p reader.app_refs

