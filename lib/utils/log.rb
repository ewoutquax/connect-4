require 'singleton'

class Log
  include Singleton

  attr_reader :logger

  def initialize
    @logger = Logger.new('/tmp/4-in-a-row.txt')
    @logger.level = $log_level
  end # /initialize

  def self.log_level=(level)
    self.instance.logger.level = level
  end

  def self.debug(args)
    self.instance.logger.debug(*args)
  end # /info

  def self.info(args)
    self.instance.logger.info(*args)
  end # /info

  def self.warn(args)
    self.instance.logger.warn(*args)
  end # /info

  def self.error(args)
    self.instance.logger.error(*args)
  end # /info
end # /Log
