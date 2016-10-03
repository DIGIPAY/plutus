# lib/generators/plutus/plutus_generator.rb
require 'rails/generators'
require 'rails/generators/migration'
require_relative 'base_generator'

module Plutus
  class BalanceLogGenerator < BaseGenerator
    def create_migration_file
      migration_template 'balance_log_migration.rb', 'db/migrate/create_plutus_balance_logs.rb'
    end
  end
end
