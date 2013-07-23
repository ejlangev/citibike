require 'spec_helper'

describe Citibike do

  it "should proxy methods to Citibike::Client" do
    Citibike::Client.expects(:stations)
    Citibike::Client.expects(:helmets)
    Citibike::Client.expects(:branches)

    Citibike.stations
    Citibike.helmets
    Citibike.branches
  end

end