class CurrencyExchangeBank# :nodoc:

  def exchange(money, currency)
    amount = CurrencyExchange.currency_exchange(money.amount, money.currency, currency)
    Money.new(amount.floor, currency, money.precision)
  end
  
  
end