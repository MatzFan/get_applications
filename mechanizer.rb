require 'mechanize'

class Mechanizer

  DETAILS_URL = 'https://www.mygov.je//Planning/Pages/PlanningApplicationDetail.aspx?s=1&r='
  DOCS_URL = 'https://www.mygov.je/Planning/Pages/PlanningApplicationDocuments.aspx?s=1&r='
  AGREEMENT = 'ctl00$SPWebPartManager1$g_f6ec2e19_056b_4a70_bbcd_9b1eb7651447$ctl00$cbDocumentAgreementCondition'
  FORM = 'aspnetForm'
  TARGET = 'ctl00$SPWebPartManager1$g_f6ec2e19_056b_4a70_bbcd_9b1eb7651447$ctl00$rptDocumentGroups$ctl01$rptDocumentGroupsItems$ctl00$LinkButton1'
  DELIM = 'ctl00_SPWebPartManager1_g_cfcbb358_c3fe_4db2_9273_0f5e5f132083_ctl00_lbl'
  DETAILS_CSS = ".//table[@class='pln-searchd-table']"
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

  attr_reader :agent, :app_ref, :details_page

  def initialize(app_ref)
    @agent = Mechanize.new
    @app_ref = app_ref
    @details_page = get_details_page
  end

  def docs_page
    docs_page = agent.get(DOCS_URL + app_ref)
  end

  def get_details_page
    agent.agent.http.ssl_version = :TLSv1 # Lord knows why this needs to be set
    agent.get(DETAILS_URL + app_ref)
  end

  def details_table(n) # app details are split over 2 tables with same class
    details_page.search(DETAILS_CSS)[n].css('tr').css('td').css('span')
  end

  def details_table_data
    (0..1).map { |n| details_table(n).map { |i| i.text } }.flatten if valid?
  end

  def valid?
    details_table_titles == DETAILS_TABLE_TITLES
  end

  def details_table_titles
    (0..1).map { |n| details_table(n).map { |i| end_(i.attr('id')) } }.flatten
  end

  def end_(text)
    text.split('ctl00_lbl').last
  end

  def get_pdf
    form = docs_page.form(FORM)
    form.add_field!('__EVENTTARGET', TARGET)
    form.add_field!('__EVENTARGUMENT', '')
    form.add_field!(AGREEMENT, 'on')
    agent.submit(form)
  end

end
