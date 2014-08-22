require 'mechanize'

class Mechanizer

  URL = 'https://www.mygov.je/Planning/Pages/PlanningApplicationDocuments.aspx?s=1&r='
  AGREEMENT = 'ctl00$SPWebPartManager1$g_f6ec2e19_056b_4a70_bbcd_9b1eb7651447$ctl00$cbDocumentAgreementCondition'
  FORM = 'aspnetForm'
  TARGET = 'ctl00$SPWebPartManager1$g_f6ec2e19_056b_4a70_bbcd_9b1eb7651447$ctl00$rptDocumentGroups$ctl01$rptDocumentGroupsItems$ctl00$LinkButton1'

  attr_reader :agent, :app_ref

  def initialize(app_ref)
    @agent = Mechanize.new
    @app_ref = app_ref
  end

  def docs_page
    docs_page = agent.get(URL + app_ref)
  end

  def get_pdf
    form = docs_page.form(FORM)
    form.add_field!('__EVENTTARGET', TARGET)
    form.add_field!('__EVENTARGUMENT', '')
    form.add_field!(AGREEMENT, 'on')
    agent.submit(form)
  end

end
