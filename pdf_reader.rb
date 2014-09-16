require 'uri'
require 'shellwords'

class PdfReader

  attr_reader :remote_url, :pdf_path, :bash_escaped_pdf_file_name

  def initialize(remote_url)
    @remote_url = remote_url
    @pdf_path = pdf_path
    @bash_escaped_pdf_file_name = bash_escaped_pdf_file_name
  end

  def encoded_pdf_file_name
    File.basename(URI.parse(remote_url).path)
  end

  def bash_escaped_pdf_file_name
    Shellwords.escape(URI.decode(encoded_pdf_file_name))
  end

  def pdf_path
    path = File.expand_path File.dirname(__FILE__) + '/' + encoded_pdf_file_name
    URI.decode(path)
  end

  def pdf_to_text(noblank = true)
    cmd = "pdftotext -enc UTF-8 '#{pdf_path}'"
    `#{cmd}`
    file = File.new(pdf_path.sub(/.pdf$/, '.txt'))
    txt_array = []
    file.readlines.each do |l|
      l.chomp! if noblank
      txt_array << l if l.length > 0
    end
    file.close
    txt_array
  end

  def download
    cmd = "curl #{remote_url} -o #{bash_escaped_pdf_file_name}"
    `#{cmd}`
    sleep(5)
  end

  def app_refs
    txt_array = pdf_to_text
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

