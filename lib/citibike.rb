# encoding: UTF-8

require 'citibike/version'
require 'citibike/connection'
require 'citibike/api'
require 'citibike/client'

# Namespace for methods of accessing real time
# Citibike data for NYC
module Citibike

  def self.method_missing(sym, *args, &block)
    if Citibike::Client.respond_to?(sym)
      return Citibike::Client.send(sym, *args, &block)
    end

    super
  end

end
