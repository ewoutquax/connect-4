require 'sequel'
require 'sqlite3'
require 'pry'
require_relative './database'

Database.instance

require_relative './player'
require_relative './aiplayer'
require_relative './human_player'
require_relative './board'
require_relative './game'
