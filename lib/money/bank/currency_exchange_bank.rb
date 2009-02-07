class CurrencyExchangeBank# :nodoc:

  def exchange(money, currency)
    return Money.new(0, currency, money.precision) if money.zero?
    amount = CurrencyExchange.currency_exchange(money.amount, money.currency, currency)
    Money.new(amount.floor, currency, money.precision)
  end
  
  
end