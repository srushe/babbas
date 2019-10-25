require 'dotenv/load'
require 'sinatra'
require './lib/babbas/application'

run Babbas::Application
