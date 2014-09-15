require 'uri'

class PdfReader

  attr_reader :remote_url, :pdf_path

  def initialize(remote_url)
    @remote_url = remote_url
    @pdf_path = pdf_path
  end

  def pdf_path
    path = File.expand_path File.dirname(__FILE__) + '/' + File.basename(URI.parse(URI.encode(remote_url)).path)
    URI.decode(path)
  end

  def pdf_to_text(noblank = true)
    cmd = "pdftotext -enc UTF-8 '#{pdf_path}'"
    `#{cmd}`
    # file = File.new(file.sub(/.pdf$/, '.txt'))
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
    cmd = "wget '#{remote_url}'"
    `#{cmd}`
    sleep(5)
  end

  def app_refs
    txt_array = pdf_to_text
    txt_array.select { |t| t =~ /^[A-Z]{1,3}\/\d{4}\/\d{4}$/ rescue nil }.uniq
  end

end

# pdf = 'http://www.gov.je/SiteCollectionDocuments/Planning%20and%20building/A%20PAP%2028%2008%202014.pdf'
# reader = PdfReader.new(pdf)
# file = reader.download
# text = reader.pdf_to_text(file)
# p reader.app_refs

