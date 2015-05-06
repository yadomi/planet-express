require 'thor'
require 'gitable/uri'
require 'net/ssh'

require 'planet/version'

module Planet
  class << self
    attr_accessor :configuration, :servers
  end

  class Configuration
    attr_accessor :branch, :repository, :keys, :deploy_to
  end

  class Server
    attr_accessor :ssh, :uri
  end

  def self.target(s)
    self.servers ||= Hash.new
    self.servers[s] = Server.new

    yield servers[s]
    servers[s].uri = Gitable::URI.parse(servers[s].ssh)
    servers[s].uri.path = '~/' + servers[s].uri.path unless servers[s].uri.path[0] == '/' 

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
      end

      desc 'setup NAME', 'Create the remote git repository and install push hooks for it'
      def setup(target)
        uri = Planet.servers[target.to_sym].uri
        Net::SSH.start(uri.host, uri.user, :keys => [ Planet.configuration.keys ]) do |ssh|
          cmd = %{  
            mkdir -p #{uri.path} && 
            cd #{uri.path} && 
            git clone --depth 1 #{Planet.configuration.repository} . 
          }
          ssh.exec(cmd)
        end
      end

      desc 'deploy TARGET [BRANCH]', 'Deploy the application to the specified target'
      def deploy(target, branch='master')
        uri = Planet.servers[target.to_sym].uri
        Net::SSH.start(uri.host, uri.user, :keys => [ Planet.configuration.keys ]) do |ssh|
          cmd = %{
            cd #{uri.path} && \
            git pull origin #{branch} 
          }
          ssh.exec(cmd)
        end
      end

    end
  end
end 