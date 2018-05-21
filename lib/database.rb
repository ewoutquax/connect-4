require 'singleton'

class Database
  include Singleton

  def initialize
    @db = Sequel.connect('sqlite://data/game.db')

    begin
      @db.create_table :q_states do
        primary_key :id
        String :state
        Integer :move
        Integer :counter
        Float :value
      end
      @db.create_table :v_states do
        primary_key :id
        String :state
        Float :value
      end
      @db.run('ALTER TABLE `v_states` ADD UNIQUE INDEX `state` (`state`)')
      @db.run('ALTER TABLE `q_states` ADD UNIQUE INDEX `state_move` (`state`,`move`)')

    rescue Sequel::DatabaseError => _e

    end
  end

  def connection()
    @db
  end
end
