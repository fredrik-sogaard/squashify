class Club
  include ActiveModel::Model

  attr_accessor :name, :prefix

  def data_url date
    "http://#{self.prefix}.bestille.no/Customer/Beta/Services/ScheduleData.aspx?s=20&d=#{date.strftime("%Y%m%d")}&v=&df=#{Date.today.strftime("%Y%m%d")}"
  end

  def link_url date
    "https://#{self.prefix}.bestille.no/Customer/Beta/Schedule.aspx?s=20&d=#{date.strftime("%Y%m%d")}"
  end

end
