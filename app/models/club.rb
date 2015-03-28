class Club
  include ActiveModel::Model

  attr_accessor :name, :prefix

  @clubs = [
    Club.new( name: "Sagene", prefix: "sagenesquash" ),
    Club.new( name: "Skippern", prefix: "skippernsquash"),
    Club.new( name: "Vulkan", prefix: "vulkansquash"),
    Club.new( name: "Sentrum", prefix: "sentrumsquash")
  ]

  def self.all
    @clubs
  end

  def data_url date
    "http://#{self.prefix}.bestille.no/Customer/Beta/Services/ScheduleData.aspx?s=20&d=#{date.strftime("%Y%m%d")}&v=&df=#{Date.today.strftime("%Y%m%d")}"
  end

  def link_url date
    "https://#{self.prefix}.bestille.no/Customer/Beta/Schedule.aspx?s=20&d=#{date.strftime("%Y%m%d")}"
  end

end
