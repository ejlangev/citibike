require 'spec_helper'

describe Citibike::Station do

  let(:stations) do
    Citibike.stations
  end

  let(:stat) do
    stations.first
  end

  around(:each) do |example|
    VCR.use_cassette(:station, record: :new_episodes) do
      example.run
    end
  end

  it "should provide consistent accessor methods" do
    stat.nearby_stations.should be_a(Array)
    # this field is nil for some reason
    stat.should respond_to(:station_address)
    stat.available_docks.should be_a(Integer)
    stat.available_bikes.should be_a(Integer)

    stat.should be_active
  end

  it "should provide a helper for nearby station ids" do
    stat.nearby_station_ids.should be_a(Array)
    stat.nearby_station_ids.first.should be_a(Integer)
  end

  context ".distance_to_nearby" do
    it "should provide a helper to get the distance to a nearby station" do
      stat.distance_to_nearby(
        stat.nearby_station_ids.first
      ).should be_a(Float)
    end

    it "should raise an error if the provided id is not nearby" do
      lambda{
        stat.distance_to_nearby(stat.nearby_station_ids.sum)
      }.should raise_error
    end
  end

end