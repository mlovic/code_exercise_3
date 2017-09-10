class StandardPrice
  def initialize(price)
    @price = price
  end

  def calculate_price(quant)
    quant * @price
  end
end
