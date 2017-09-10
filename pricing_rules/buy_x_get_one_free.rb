class BuyXGetOneFree
  # Using x as a variable name, as I think the meaning is clear from
  # looking at the class name. I would like to know what others think.
  def initialize(price, x)
    @single_unit_price = price
    @x = x
  end

  def calculate_price(quant)
    (quant - quant / @x) * @single_unit_price
  end
end
