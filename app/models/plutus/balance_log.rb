module Plutus
  # The BalanceLog class represents the monthly opening balance of the month
  #
  # @abstract
  #   A balance log must always conform with the settled balance 
  #   of the account
  #
  # @author Michael Bulat
  class BalanceLog < ActiveRecord::Base
    belongs_to :account, class_name: 'Plutus::Account'
    validates_presence_of :account_id, :month_index

    after_create :initialize_balance

    def initialize_balance
      month_balance = account.balance({from_date: "1970-01-01 00:00:00",
                       to_date: "%d-%02d-01 00:00:00" % [month_index / 100,
                                                         month_index % 100]})
      update(balance: month_balance)
    end
    
  end
end
