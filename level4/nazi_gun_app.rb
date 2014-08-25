require 'sinatra'
require 'data_mapper'
require 'dm-ar-finders'

PREFIX = ENV['NAZI_PREFIX'] || ''

module MoonNazis
  class User
    include DataMapper::Resource

    property :id, Serial
    property :login, String
    property :password_hash, String
    property :password_salt, String

    def valid_password?(password)
      Digest::SHA256.hexdigest(password + password_salt) == password_hash
    end

    def self.find_by_login(login)
      find_by_sql(%(
        SELECT id, login, password_hash, password_salt
        FROM moon_nazis_users
        WHERE login = '#{login}')).first
    end
  end

  class Gun
    include DataMapper::Resource

    property :id, Serial
    property :name, String
  end

  class FirstRun
    include DataMapper::Resource

    property :id, Serial
  end

  DataMapper.finalize

  def self.first_run?
    FirstRun.count == 0
  end

  def self.setup_data
    return unless first_run?
    FirstRun.create!
    ['hans', 'fuhrer', 'brunhilda'].each do |login|
      password = SecureRandom.hex
      salt = SecureRandom.hex
      hash = Digest::SHA256.hexdigest(password+salt)
      User.create!(login: login, password_hash: hash, password_salt: salt)
    end

    ['uber-laser', 'lonenkanone', 'nazi-super-gun'].each do |name|
      Gun.create!(name: name)
    end
  end

  def self.setup_connection(connection_string)
    DataMapper.setup(:default, connection_string)
    DataMapper.auto_upgrade!
  end

  class NaziGunApp < Sinatra::Base
    set :root, File.dirname(__FILE__)

    def prefix(path)
      prefix = env['nazi.prefix'] || PREFIX
      prefix + path
    end

    before do
      if env['nazi.db']
        MoonNazis.setup_connection(env['nazi.db'])
        MoonNazis.setup_data
      end
    end

    set :authorized_personnel do |user|
      condition do
        if session[:current_nazi] != user
          redirect prefix("/")
          halt
        end
      end
    end

    get PREFIX+"/" do
      erb :login
    end

    post PREFIX+"/login" do
      user = User.find_by_login(params[:login])
      password = params[:password]

      if user && user.valid_password?(password)
        session[:current_nazi] = user.login
        redirect prefix("/guns")
      else
        redirect prefix("/")
      end
    end

    get PREFIX+"/guns", :authorized_personnel => 'fuhrer' do
      @guns = Gun.all
      erb :guns
    end

    post PREFIX+"/self-destruct", :authorized_personnel => 'fuhrer' do
      Gun.destroy!
      redirect prefix("/guns")
    end
  end
end
