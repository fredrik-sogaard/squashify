class Slot
  include ActiveModel::Model

  @slots = []

  attr_accessor :club, :lane, :time, :available

  def self.all(params = {})
    slots = @slots
    [:club, :lane, :time, :available, :available_hour].each do |param|
      slots = slots.select { |slot| slot.send(param)==params[param] } unless params[param].nil?
    end
    slots = slots.select { |slot| slot.time[0..1].to_i>=params[:first_time] } unless params[:first_time].nil?
    slots = slots.select { |slot| slot.time[0..1].to_i<=params[:last_time]  } unless params[:last_time].nil?
    slots
  end

  def self.first(params = {})
    self.all(params).first
  end

  def self.available(params = {})
    slot = self.first(params)
    return nil if slot.nil?
    return slot.available
  end

  def self.load(date=nil)
    @slots = []
    date = Date.today.next_day.strftime("%Y%m%d") if date.nil?

    date_of_order = Date.today.strftime("%Y%m%d")
    clubs = {
      "Sagene"   => "http://sagenesquash.bestille.no/Customer/Beta/Services/ScheduleData.aspx?s=20&d=#{date}&v=&df=#{date_of_order}",
      "Skippern" => "http://skippernsquash.bestille.no/Customer/Beta/Services/ScheduleData.aspx?s=20&d=#{date}&v=&df=#{date_of_order}",
    }
    clubs.each do |club, url|
      HTTP.get(url).to_s.scan(/<td class="slot[^>]+>/).each do |x|
        slot = Slot.new(
          club: club.to_s,
          lane: x.match(/title="(.*) kl/)[1].gsub(".",""),
          time: x.match(/kl (\d{2}:\d{2})/)[1],
          available: x.match("unavailable").nil?
        )
        @slots << slot
      end
    end
  end

  def self.clubs
    @slots.map { |slot| slot.club }.uniq.sort
  end

  def self.times
    @slots.map { |slot| slot.time }.uniq.sort
  end

  def self.club_lanes
    @slots.map { |slot| [slot.club,slot.lane] }.uniq.sort
  end

  def available_hour
    return false unless self.available
    next_time = Slot.times[Slot.times.index(self.time)+1]
    return Slot.available(club: self.club, lane: self.lane, time:next_time) ? true : false

  end

end
