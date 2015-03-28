class Slot
  include ActiveModel::Model

  attr_accessor :club, :lane, :date, :time, :available

  @slots = []

  def self.all(params = {})
    slots = @slots
    [:club, :lane, :time, :date, :available, :available_hour].each do |param|
      slots = slots.select { |slot| slot.send(param)==params[param] } unless params[param].nil?
    end
    slots = slots.select { |slot| slot.time[0..1].to_i>=params[:first_time] } unless params[:first_time].nil?
    slots = slots.select { |slot| slot.time[0..1].to_i<=params[:last_time]  } unless params[:last_time].nil?
    slots
  end

  def self.first(params = {})
    self.all(params).first
  end

  def self.status(params = {})
    slots = self.all(params)
    return :double if slots.select { |slot| slot.available_double_hour }.size>0
    return :hour if slots.select{ |slot| slot.available_hour }.size>0
    return :none
  end

  def self.load(date=Date.today.next_day)
    @slots = []

    hydra = Typhoeus::Hydra.hydra

    requests = Club.all.map { |club|
      request = Typhoeus::Request.new(club.data_url(date), followlocation: true)
      hydra.queue(request)
      [club, request]
    }
    hydra.run

    requests.each do |club,request|
      request.response.body.to_s.scan(/<td class="slot[^>]+>/).each do |x|
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

  def self.times
    @slots.map { |slot| slot.time }.uniq.sort
  end

  def self.club_lanes
    @slots.map { |slot| [slot.club,slot.lane] }.uniq.sort
  end

  def next_time
    Slot.times[Slot.times.index(self.time)+1]
  end

  def available_hour
    return false unless self.available
    return Slot.all(club: self.club, time:self.next_time, available:true).size>0 ? true : false
  end

  def available_double_hour
    slots = Slot.all(club: self.club, time:self.time, available_hour:true)
    return slots.size>1
  end

end
