require 'json'
require 'logger'
require 'redis'
require 'pry'

require_relative './utils/log'
require_relative './utils/database'
require_relative './entities/player/base'
require_relative './entities/player/human'
require_relative './entities/player/ai'
require_relative './entities/player/base'
require_relative './entities/board'
require_relative './entities/game'
require_relative './services/drawer/board'
require_relative './services/arbiter/win'
require_relative './services/arbiter/valid_moves'
require_relative './services/arbiter/game_end'

$log_level = :info
