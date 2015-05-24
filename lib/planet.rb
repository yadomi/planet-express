require 'thor'
require 'gitable/uri'
require 'net/ssh'

require 'planet/version'

module Planet
  class << self
    attr_accessor :configuration, :servers
  end

  class Configuration
    attr_accessor :branch, :repository, :key
  end

  class Server
    attr_accessor :ssh, :uri, :key
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
      LOCAL_DIR = File.expand_path('..', __FILE__)



      def initialize(*args)
        super

        unless initialized? then return end

        if not File.file?(File.join(Dir.pwd, PLANET_FILE))
          abort 'No Planetfile found in current folder'
        end

        @@planetfile = File.join(Dir.pwd, PLANET_FILE)
        load @@planetfile

      end



      desc 'init', 'Initialize project with a dummy Planetfile and adds deploy scripts'
      def init

        if initialized? then 
          abort 'This projet has already been initialized with a Planetfile'
        end

        Dir.mkdir 'deploy/'
        template_dir = File.join(LOCAL_DIR, 'template')
        FileUtils.cp(File.join(template_dir, PLANET_FILE), '.')
        FileUtils.cp(File.join(template_dir, 'after_deploy.sh'), 'deploy/')
        FileUtils.chmod "u=wrx,go=rx", 'deploy/after_deploy.sh'

      end



      desc 'setup TARGET', 'Create the git repository on the remote and install hooks on it'
      def setup(target)

        unless initialized? then 
          abort "This project hasn't been initialized. Run planet init to initialize and commit your changes"
        end

        uri = Planet.servers[target.to_sym].uri
        Net::SSH.start(uri.host, uri.user, :keys => [Planet.servers[target.to_sym].key] ) do |ssh|

          if Planet.configuration.key 
            cmd = %{ ssh-agent bash -c '
              ssh-add #{Planet.configuration.key } &&
              git clone #{Planet.configuration.repository} #{uri.path}' } 
          else
            cmd = %{ git clone --depth 1 #{Planet.configuration.repository} #{uri.path} }
          end
          ssh.exec(cmd)
        end
      end



      desc 'deploy TARGET [BRANCH]', 'Deploy the application to the specified target'
      def deploy(target, branch = Planet.configuration.branch )
        uri = Planet.servers[target.to_sym].uri
        Net::SSH.start(uri.host, uri.user, :keys => [Planet.servers[target.to_sym].key] ) do |ssh|
          cmd = %{
            cd #{uri.path} && \
            git checkout #{branch} && \
            git pull origin #{branch} && \
            cd #{uri.path} && sh ./deploy/after_deploy.sh
          }
          ssh.exec(cmd)
        end
      end



      private
      def initialized?
        cmd = %x[git ls-files | grep -c '#{PLANET_FILE}' ].chomp!
        if cmd === '0' then false else true end
      end

    end
  end
end 