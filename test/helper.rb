require 'test/unit'
require 'pp'

ENV['ENV'] = 'test'
require File.expand_path('../../config/boot', __FILE__)

module Vault
  def self.encrypt(data)
    @cipher.encrypt(data)
  end
end

class Test::Unit::TestCase
  @@fixtures = {}
  def self.fixtures(*args)
    args.flatten.each do |fixture|
      self.class_eval do
        define_method(fixture) do |item|
          @@fixtures[fixture] ||= YAML::load_file(File.expand_path('../../test', __FILE__) + "/fixtures/#{fixture.to_s}.yml")
          @@fixtures[fixture][item.to_s]
        end
      end
    end
  end
end

class NotificationHandler::TestCase < Test::Unit::TestCase
  def sc(data)
    Vault.encrypt(data.to_msgpack)
  end
end