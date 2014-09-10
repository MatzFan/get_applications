require 'bundler'
Bundler.setup
require 'xpdf'

class PdfReader

  def initialize
  end

  def pdf_to_text(file, noblank = true)
    spec = file.sub(/.pdf$/, '')
    `pdftotext #{spec}.txt`
    file = File.new("#{spec}.txt")
    text = []
    file.readlines.each do |l|
      l.chomp! if noblank
      if l.length > 0
        text << l
      end
    end
    file.close
    text
  end

end

file = '/Users/me/Downloads/A MM 5.9.2014.pdf'
PdfReader.new.pdf_to_text(file)
