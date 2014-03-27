class MyMoneyService
  include Service::Base
  # require a money object to call this service
  service_init(:money)

  def change(options = {})
    currency = options[:currency]

    return currency.convert(money, nil) # maybe have better logic..
  end

  def exchange(options = {})
    options[:currency].convert(money, options[:rate]) # maybe have better logic..
  end

end





class MoneyController

  def convert
    result = service(:my_money).invoke(:change, currency: currency, money: money)

    case result.code
    when :success
      redirect_to money_url(result.object), notice: 'Successfully converted all your money'
    else
      redirect_to root_url, alert: "Your money be lost in translation"
    end
  end

  private

  def service(name, options = {})
    @services[name.to_sym] ||= Service::Base.service(name, options)
  end
end

