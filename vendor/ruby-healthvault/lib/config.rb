# -*- ruby -*-
#--
# Copyright 2008 Danny Coates, Ashkan Farhadtouski
# All rights reserved.
# See LICENSE for permissions.
#++

require 'logger'
require 'singleton'

module HealthVault
  class Configuration
    include Singleton
    attr_accessor :app_id, :cert_file, :cert_pass, :shell_url, :hv_url, :logger
    
    #default values to the HelloWorld sample.
    #theses should be set by your application
    #using HealthVault::Configuration.instance accessor methods
    def initialize
      @app_id = ENV['HVAPPID']
      @cert_file = File.dirname(__FILE__) + "/../bin/certs/symplmed.pem"
      @cert_pass = ""
      @shell_url = ENV['HVSHELLURL']
      @hv_url = ENV['HVSHELLURL'] + ENV['HVURL']
      @logger = Logger.new("hv.log")
    end
  end
end