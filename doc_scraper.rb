require 'mechanize'
require 'open-uri'

class DocScraper

  ROOT = 'http://www.gov.je'
  URL = 'http://www.gov.je/PlanningBuilding/PublicPlanningMeetings/Pages/AgendasMinutes.aspx'
  PAP = 'Planning Applications Panel'
  MH = 'Ministerial Hearing'
  PAP_TEXT = ['PAP', 'Panel'] # text in url which determines doc type is PAP

  attr_reader :agent, :doc, :pap_links, :mh_links, :upcoming

  def initialize
    @agent = Mechanize.new(URL)
    @doc = Nokogiri::XML(open(URL))
    @pap_links = link_types(1)
    @mh_links = link_types(2)
  end

  def link_types(t_num)
    doc.css('table')[t_num].css('a').map { |link| ROOT + link.attr('href') }
  end

  def page_source
    agent.get(URL)
  end

  def doc_links
    page_source.links.select { |link| link.text.include?('Download ') }
  end

  def doc_uris
    doc_links.map { |link| ROOT + link.uri.to_s }
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

  def d_type(uri) # fallback method to identify document type from file name
    PAP_TEXT.any? { |text| File.basename(uri).include?(text) } ? PAP : MH
  end

  def meeting_types
    doc_uris.map do |uri|
      pap_links.include?(uri) ? PAP : mh_links.include?(uri) ? MH : d_type(uri)
    end
  end

  def meet_type_date
    join(meeting_types.zip(doc_dates))
  end

  def meetings
    meet_type_date.uniq
  end

  def documents
    join(doc_types.zip(doc_uris).zip(meet_type_date.map { |e| e.sub('|','') }))
  end

  def join(array)
    array.map { |e| e.join('|') }
  end

end

# s = DocScraper.new
# pp s.meeting_types
# pp s.doc_links
# pp s.doc_uris
# pp s.doc_dates
# pp s.meetings
# puts s.meetings
# puts s.documents
# .each { |meet| puts meet[0] + ' ' + meet[1] }
# s.pdf(s.doc_uris[2])


