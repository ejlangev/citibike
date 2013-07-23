# Citibike - Wrapper for the unofficial Citibike NYC API
[![Build Status](https://secure.travis-ci.org/ejlangev/citibike.png)](http://travis-ci.org/ejlangev/citibike) [![Code Climate](https://codeclimate.com/github/ejlangev/citibike.png)](https://codeclimate.com/github/ejlangev/citibike) [![Coverage Status](https://coveralls.io/repos/ejlangev/citibike/badge.png?branch=master)](https://coveralls.io/r/ejlangev/citibike)

A simple gem for interacting with the city bike api.  Gives you back
objects by default with consistently named methods for accessing data.
Also allows easy geographical searching for nearby stations via
latitude and longitude and as the crow flies distance.

I based it partially on another gem [citibikenyc](https://github.com/edgar/citibikenyc) but wanted to design mine a bit differently/play around with the API from scratch.

All contributions are welcome.

## Installation

Add this line to your application's Gemfile:

    gem 'citibike'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install citibike

## Usage

### Defaults
```ruby
  # Here's an example for stations, it also provides data about
  # branches and helmets with more or less equivalent methods
  helmets = Citibike.helmets
  branches = Citibike.branches

  # Returns a Citibike::Responses::Station object
  stations = Citibike.stations

  # This object contains the attributes of the response
  stations.success?     # True if the response was successful
  stations.last_update  # The time this data was last updated

  # The response object includes Enumerable and proxies
  # unknown methods to an underlying array
  stations.each do |s|
    puts s.class              # Citibike::Station
    puts s.latitude           # Float
    puts s.longitude          # Float
    puts s.available_bikes    # Integer
    puts s.available_docks    # Integer
    puts s.id                 # Integer id
  end

  # It's also simple to find stations within a given distance
  # (in miles) of a LAT/LONG pair (in degrees)
  # nearby will be an array of Citibike::Station objects
  nearby = stations.all_within(LAT, LONG, DISTANCE)

  # You can do the same thing given an instance of Citibike::Station
  # Note that the results do NOT include station itself
  nearby = stations.all_near(station, DISTANCE)

  # It's also convenient to look up results by id within the
  # list of stations
  station = stations.find_by_id(ID)

  # It also supports a variadic version
  stats = stations.find_by_ids(ID1, ID2,...)

  # Sometimes it might be convenient to a list of stations
  # but still retain the methods of the Citibike::Responses::Station
  # object.
  filtered_stations = stations.clone_with(stations.select(&:active?))
```

### Configuration
If you want to change the default configuration for web requests it
is simple to do so given that it is using Faraday under the hood.
Simply create an instance of Citibike::Client and pass a hash of
your settings overrides.

```ruby
  client = Citibike::Client.new   # initializes a default client

  client.stations                 # returns Citibike::Responses::Station
  client.helmets                  # returns Citibike::Responses::Helmet
  client.branches                 # returns Citibike::Responses::Branch

  # The simplest option is to unwrap the responses in which case they
  # come back as a simple hash not a custom object
  client = Citibike::Client.new(unwrapped: true)
  client.stations                 # Instance of Hash

  # Other configuration options and their default values
  {
    adapter: Faraday.default_adapter,
    headers: {
      'Accept' => 'application/json; charset=utf-8',
      'UserAgent' => 'Citibike Gem'
    },
    proxy: nil,
    ssl: {
      verify: false
    },
    debug: false,          # Turns on connection logging(currently unused)
    test: false,           # True if in a test
    stubs: nil,            # Stubs for the test connection
    raw: false,            # Don't process the response in any way
    format_path: true,     # Append the format to the request path  if it lacks one
    format: :json,         # Default format
    url: 'http://appservices.citibikenyc.com/'
  }
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
