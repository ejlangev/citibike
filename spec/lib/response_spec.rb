require 'spec_helper'

describe "Responses" do

  around(:each) do |example|
    VCR.use_cassette(:responses, record: :new_episodes) do
      example.run
    end
  end

  # Currently only the superclass has actual methods so testing
  # on just stations is sufficient

  let(:stations) { Citibike::Client.stations }

  it "should provide a success? method" do
    stations.should be_a_success
  end

  it "should parse last_update into a time" do
    stations.last_update.should be_a(Time)
  end

  it "should be enumerable" do
    ids = stations.collect(&:id)

    ids.should be_a(Array)
    ids.first.should be_a(Integer)
  end

  it "should be able to clone itself on a subset of its data" do
    size = stations.size
    actives = stations.select(&:active?)
    actives.size.should_not eql(size)

    stats2 = stations.clone_with(actives)
    stats2.size.should eql(actives.size)

    stats2.last_update.should eql(stations.last_update)
    stats2.object_id.should_not eql(stations.object_id)
  end

  it "should be able to find another object by id" do
    ids = stations.first.nearby_station_ids

    stat = stations.find_by_id(ids.first)
    stat.id.should eql(ids.first)
    stat.should be_a(Citibike::Station)
  end

  it "should be able to search for multiple ids at once" do
    ids = stations[1].nearby_station_ids

    stats = stations.find_by_ids(*ids)
    stats.collect(&:id).should eql(ids)
  end

  # This conveniently tests that the code for computing
  # distance as the crow flies from lat/long works correctly
  context "Geolocating" do

    it "should be able to find stations in a given radius" do
      stat = stations.first
      dists = stat.nearby_station_ids.collect do |i|
        stat.distance_to_nearby(i)
      end

      res = stations.all_within(stat.lat, stat.long, dists.max + 0.001)
      res.count.should eql(stat.nearby_station_ids.size + 1)
      ([stat.id] + stat.nearby_station_ids).sort.should eql(
        res.collect(&:id).sort
      )

    end

    it "should be able to find all stations within a given radius of another
    station" do
      stat = stations[1]
      dists = stat.nearby_station_ids.collect do |i|
        stat.distance_to_nearby(i)
      end

      res = stations.all_near(stat, dists.max + 0.001)
      res.count.should eql(stat.nearby_station_ids.size)
      stat.nearby_station_ids.sort.should eql(res.collect(&:id).sort)
    end

  end

end