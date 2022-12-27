$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require 'feet'
require 'rack/test'
require 'feet/utils'
require 'feet/sqlite_model'

require 'minitest/autorun'
