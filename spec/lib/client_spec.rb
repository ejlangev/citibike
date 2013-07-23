require 'spec_helper'
require 'debugger'

Debugger.start

describe Citibike::Client do
  context "Class Methods" do

    around(:each) do |example|
      VCR.use_cassette(:client_class, record: :new_episodes) do
        example.run
      end
    end

    context "#stations" do
      it "should load a list of stations" do
        stats = Citibike::Client.stations

        stats.first.should be_a(Citibike::Station)
        stats.first.should respond_to(:lat)
        stats.first.should respond_to(:long)
      end
    end

    context "#helmets" do
      it "should load a list of helmets" do
        helms = Citibike::Client.helmets

        helms.first.should be_a(Citibike::Helmet)
        helms.first.latitude.should_not be_nil
        helms.first.longitude.should_not be_nil
      end
    end

    context "#branches" do
      it "should load a list of branches" do
        branches = Citibike::Client.branches

        branches.should be_a(Citibike::Responses::Branch)
        branches.first.should be_a(Citibike::Branch)
      end
    end

  end

  context "Instance Methods" do

  end
end