module Plutus
  # The Amount class represents debit and credit amounts in the system.
  #
  # @abstract
  #   An amount must be a subclass as either a debit or a credit to be saved to the database.
  #
  # @author Michael Bulat
  class Amount < ActiveRecord::Base
    belongs_to :entry, :class_name => 'Plutus::Entry'
    belongs_to :account, :class_name => 'Plutus::Account'

    validates_presence_of :type, :amount, :entry, :account
    # attr_accessible :account, :account_name, :amount, :entry

    # Assign an account by name
    def account_name=(name)
      self.account = Account.find_by_name!(name)
    end

    # Returns the account's running balance at the point of creation of the
    # amount. This utilizes the internal balance log based on the date
    # TODO: Delete all subsequent balances 
    #
    # @example
    #   credit_amounts.running_balance
    #   => #<BigDecimal:103259bb8,'0.2E4',4(12)>
    #
    # @return [BigDecimal] The decimal value balance
    def running_balance
      month_index = entry.created_at.strftime("%Y%m").to_i
      balance_log = Plutus::BalanceLog.find_by(month_index: month_index,
                                               plutus_account_id: account_id)
      if balance_log.nil?
        balance_log = Plutus::BalanceLog.create(
          plutus_account_id: account_id,
          month_index: month_index)
      end
      # Then get the total balance by adding the balance from_date to entry's
      # created_at
      return balance_log.balance + 
        account.balance({ 
          from_date: entry.created_at.strftime("%Y-%m-01 00:00:00"),
          to_date: entry.created_at.strftime("%Y-%m-%d %H:%M:%S") })

    end

    protected

    # Support constructing amounts with account = "name" syntax
    def account_with_name_lookup=(v)
      if v.kind_of?(String)
        ActiveSupport::Deprecation.warn('Plutus was given an :account String (use account_name instead)', caller)
        self.account_name = v
      else
        self.account_without_name_lookup = v
      end
    end
    alias_method_chain :account=, :name_lookup
  end
end
