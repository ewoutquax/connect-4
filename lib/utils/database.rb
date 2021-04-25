require "singleton"

class Database
  include Singleton

  attr_reader :redis

  DATABASE_NAME = "4-in-a-row".freeze

  def initialize
    db_nr = ($test_env) ? 1 : 0

    @redis = Redis.new(db: db_nr)
  end

  def self.name
    DATABASE_NAME
  end

  def self.connection
    self.instance.redis
  end

  def self.exists(key)
    connection.hexists(self.name, key)
  end

  def self.set(key, value)
    connection.hset(self.name, key, value)
  end

  def self.get(key)
    connection.hget(self.name, key)
  end

  def self.getall
    connection.hgetall(self.name)
  end

  def self.flushdb
    connection.flushdb
  end
end
