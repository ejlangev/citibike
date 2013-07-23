require 'spec_helper'

describe Citibike::Connection do

  let(:stubs) do
    Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get('/test_path.json') { [200, {}, {:a => :b}.to_json] }
      stub.get('/test_no_format') { [200, {}, {:c => :d}.to_json] }
      stub.get('/provider_format.xsl') { [200, {}, {:e => :f}.to_json] }
    end
  end

  it "should append the default format (.json) and parse the json" do
    conn = Citibike::Connection.new(
      :adapter => :test,
      :stubs => stubs,
      :test => true
    )
    result = conn.request(:get, '/test_path')
    result.should be_a(Hash)

    result['a'].should eql('b')
  end

  it "should not append the format if format_path is false" do
    conn = Citibike::Connection.new(
      :adapter => :test,
      :stubs => stubs,
      :format_path => false,
      :format => :xml,
      :test => true
    )

    result = conn.request(:get, '/test_no_format')
    result.should be_a(Hash)

    result['c'].should eql('d')
  end

  it "should not append the format if one is already provided" do
    conn = Citibike::Connection.new(
      :adapter => :test,
      :stubs => stubs,
      :test => true
    )

    result = conn.request(:get, '/provider_format.xsl')
    result.should be_a(Hash)

    result['e'].should eql('f')
  end

  it "should not parse the json if raw is true" do
    conn = Citibike::Connection.new(
      :adapter => :test,
      :stubs => stubs,
      :raw => true,
      :test => true
    )

    result = conn.request(:get, '/test_path')
    result.should be_a(String)

    result = JSON.parse(result)
    result['a'].should eql('b')
  end

end