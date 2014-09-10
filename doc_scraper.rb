require 'mechanize'
require 'open-uri'
require 'pdf-reader'

class DocScraper

  ROOT = 'http://www.gov.je'
  URL = 'http://www.gov.je/PlanningBuilding/PublicPlanningMeetings/Pages/AgendasMinutes.aspx'
  PAP = 'Planning Applications Panel'
  MH = 'Ministerial Hearing'
  PAP_TEXT = ['PAP', 'Panel'] # text in url which determines doc type is PAP

  attr_reader :agent

  def initialize
    @agent = Mechanize.new(URL)
  end

  def page_source
    agent.get(URL)
  end

  def doc_links
    page_source.links.select { |link| link.text.include?('Download ') }
  end

  def doc_uris
    doc_links.map { |link| URI.unescape(link.uri.to_s) }
  end

  def doc_names
    doc_links.map { |link| link.text.encode }
  end

  def doc_types
    doc_names.map { |name| name.include?('agenda') ? 'Agenda' : 'Minutes' }
  end

  def doc_dates
    doc_names.map { |name| Date.parse(name).strftime("%d/%m/%Y") }
  end

  def meeting_types
    doc_uris.map { |uri| PAP_TEXT.any? { |txt| uri.include?(txt) } ? PAP : MH } # NOT RELIABLE
  end

  def meetings
    meeting_types.zip(doc_dates).uniq.map { |e| e.join('') }
  end

  # def pdf(url)
  #   PDF::Reader.new open(URI.encode(ROOT + url))
  # end

  # def text(pdf)
  #   pdf.pages.each { |page| puts page.walk }
  # end

end

s = DocScraper.new
# pp s.doc_links
# pp s.doc_uris
# pp s.doc_dates
# pp s.meeting_types
# puts s.meetings
# .each { |meet| puts meet[0] + ' ' + meet[1] }
# s.pdf(s.doc_uris[2])


