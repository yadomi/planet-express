require 'thor'
require 'planet/version'

module Planet
  class << self
    attr_accessor :configuration, :servers
  end

  class Configuration
    attr_accessor :branch, :repository, :keys, :deploy_to
  end

  class Server
    attr_accessor :url
  end

  def self.target(s)
    self.servers ||= Hash.new
    self.servers[s] = Server.new
    yield servers[s]
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield configuration
  end

  module Cli
    class Application < Thor

      PLANET_FILE = 'Planetfile'

      def initialize(*args)
        super
        if not File.file?(File.join(Dir.pwd, PLANET_FILE))
          raise 'No Planetfile found in current folder'
        end
        @@planetfile = File.join(Dir.pwd, PLANET_FILE)
        load @@planetfile
        puts Planet.servers
      end

      desc 'setup NAME', 'Create the remote git repository and install push hooks for it'
      def setup(name)
        puts "Hello #{name}"
      end

    end
  end
end