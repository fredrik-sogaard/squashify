class Slot
  include ActiveModel::Model

  @slots = []
  @clubs = []

  attr_accessor :club, :lane, :date, :time, :available

  def self.all(params = {})
    slots = @slots
    [:club, :lane, :time, :date, :available, :available_hour].each do |param|
      slots = slots.select { |slot| slot.send(param)==params[param] } unless params[param].nil?
    end
    slots = slots.select { |slot| slot.time[0..1].to_i>=params[:first_time] } unless params[:first_time].nil?
    slots = slots.select { |slot| slot.time[0..1].to_i<=params[:last_time]  } unless params[:last_time].nil?
    slots
  end

  def self.clubs
    @clubs
  end

  def self.first(params = {})
    self.all(params).first
  end

  def self.available(params = {})
    slot = self.first(params)
    return nil if slot.nil?
    return slot.available
  end

  def self.load(date=Date.today.next_day)
    @slots = []

    @clubs = [
      Club.new( name: "Sagene", prefix: "sagenesquash" ),
      Club.new( name: "Skippern", prefix: "skippernsquash"),
      Club.new( name: "Vulkan", prefix: "vulkansquash"),
      Club.new( name: "Sentrum", prefix: "sentrumsquash")
    ]
    @clubs.each do |club|
      HTTP.get(club.data_url(date)).to_s.scan(/<td class="slot[^>]+>/).each do |x|
        slot = Slot.new(
          club: club,
          lane: x.match(/title="(.*) kl/)[1].gsub(".",""),
          date: date,
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
    return Slot.all(club: self.club, time:next_time, available:true).size>0 ? true : false
  end

end
