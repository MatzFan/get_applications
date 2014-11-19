require_relative 'spec_helper'
require './pdf_reader'
require './config/database' # sets DB_CONFIG

describe PdfReader do

  let(:reader) { PdfReader.new(DB_CONFIG, 108) }

  context "#initialize" do
    specify "should return an object of class PdfReader" do
      expect(reader.class).to eq(PdfReader)
    end
  end


  context "#download" do
    specify "should return the applications associated with the document" do
      expect(reader.download).to eq('P/2014/0672')
    end
  end

end
