require 'rubygems'
require 'bundler/setup'

ENVIRONMENT = (ENV['ENV'] || 'development')
Bundler.require(:default, ENVIRONMENT)

['lib', 'handlers'].each { |e| Dir["#{File.expand_path('../../' + e, __FILE__)}/**/*.rb"].each { |f| require f }} 
['ConfigStore', 'Vault'].each { |m| Kernel.const_get(m).send(:boot) }