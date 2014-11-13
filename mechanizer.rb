require 'mechanize'

class Mechanizer

  DOCS_URL = 'https://www.mygov.je/Planning/Pages/PlanningApplicationDocuments.aspx?s=1&r='
  AGREEMENT = 'ctl00$SPWebPartManager1$g_f6ec2e19_056b_4a70_bbcd_9b1eb7651447$ctl00$cbDocumentAgreementCondition'
  FORM = 'aspnetForm'
  TARGET = 'ctl00$SPWebPartManager1$g_f6ec2e19_056b_4a70_bbcd_9b1eb7651447$ctl00$rptDocumentGroups$ctl01$rptDocumentGroupsItems$ctl00$LinkButton1'
  DELIM = 'ctl00_SPWebPartManager1_g_cfcbb358_c3fe_4db2_9273_0f5e5f132083_ctl00_lbl'
  DETAILS_URL = 'https://www.mygov.je//Planning/Pages/PlanningApplicationDetail.aspx?s=1&r='
  DATES_URL = 'https://www.mygov.je/Planning/Pages/PlanningApplicationTimeline.aspx?s=1&r='
  TABLE_CSS = ".//table[@class='pln-searchd-table']"
  DETAILS_TABLE_TITLES = ["Reference",
                          "Category",
                          "Status",
                          "Officer",
                          "Applicant",
                          "Description",
                          "ApplicationAddress",
                          "RoadName",
                          "Parish",
                          "PostCode",
                          "Constraints",
                          "Agent"]
  COORDS = ['Latitude', 'Longitude']
  DATES_TABLE_TITLES = ['ValidDate',
                        'AdvertisedDate',
                        'endpublicityDate',
                        'SitevisitDate',
                        'CommitteeDate',
                        'Decisiondate',
                        'Appealdate']
  ID_DELIM = 'ctl00_lbl'

  attr_reader :agent, :app_ref, :details_page, :details_source, :dates_page, :dates_source

  def initialize(app_ref)
    @agent = Mechanize.new
    @app_ref = app_ref
    @details_page = get_details_page
    @details_source = details_page.body
    @dates_page = get_dates_page
    @dates_source = @dates_page.body
  end

  def docs_page
    docs_page = agent.get(DOCS_URL + app_ref)
  end

  def get_details_page
    agent.agent.http.ssl_version = :TLSv1 # Lord knows why this needs to be set
    agent.get(DETAILS_URL + app_ref)
  end

  def get_dates_page
    agent.agent.http.ssl_version = :TLSv1 # Lord knows why this needs to be set
    agent.get(DATES_URL + app_ref)
  end

  def app_coords
    COORDS.map { |coord| coord + '|' + parse_coord(details_source, coord)}
  end

  def app_dates
    dates_table_titles.zip(dates_data).map { |i| i.join('|') }
  end

  def dates_data
    dates_table.map { |i| format(i.text) } if valid_dates
  end

  def valid_dates
    dates_table_titles == DATES_TABLE_TITLES
  end

  def dates_table
    dates_page.search(TABLE_CSS).css('tr').css('td').css('span')
  end

  def dates_table_titles
    dates_table.map { |i| parse(i.attr('id')) }
  end

  def format(date_string) # date can be 'n/a', hence rescue
    DateTime.parse(date_string).strftime("%d/%m/%Y") rescue nil
  end

  def parse_coord(source, coord)
    source.split('window.MapCentre' + coord + ' = ').last.split(';').first
  end

  def details_table(n) # app details are split over 2 tables with same class
    details_page.search(TABLE_CSS)[n].css('tr').css('td').css('span')
  end

  def details_data
    (0..1).map { |n| details_table(n).map { |i| i.text } }.flatten if valid?
  end

  def app_details_no_coords
    details_table_titles.zip(details_data).map { |i| i.join('|') }
  end

  def app_details
    app_details_no_coords + app_coords
  end

  def valid? # valid details table titles
    details_table_titles == DETAILS_TABLE_TITLES
  end

  def details_table_titles
    (0..1).map { |n| details_table(n).map { |i| parse(i.attr('id')) } }.flatten
  end

  def parse(text)
    text.split(ID_DELIM).last
  end

  def get_pdf
    form = docs_page.form(FORM)
    form.add_field!('__EVENTTARGET', TARGET)
    form.add_field!('__EVENTARGUMENT', '')
    form.add_field!(AGREEMENT, 'on')
    agent.submit(form)
  end

end
