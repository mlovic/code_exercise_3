# checkout.rb
class Checkout
  class UnknownSKUError < StandardError
    def initialize(sku)
      super("UnknownSKUError: #{sku}")
    end
  end

  def initialize(catalogue)
    @catalogue = catalogue
    @cart = Hash.new(0)
  end

  def scan(sku)
    raise UnknownSKUError.new(sku) unless @catalogue.key?(sku)
    @cart[sku] += 1
  end

  def total
    @cart.reduce(0) do |sum, (sku, quant)|
      sum + @catalogue[sku].calculate_price(quant)
    end
  end
end

# pricing_rules/standard_price.rb
class StandardPrice
  def initialize(price)
    @price = price
  end

  def calculate_price(quant)
    quant * @price
  end
end

# pricing_rules/standard_price.rb
class BulkDiscount
  def initialize(single_unit_price, bulk_prices)
   @prices_by_min_quantity = bulk_prices.merge(0 => single_unit_price)
                                        .sort
                                        .reverse
  end

  def calculate_price(quant)
    quant * lowest_price_for_order_size(quant)
  end

  private
  def lowest_price_for_order_size(quant)
    @prices_by_min_quantity.find { |min_order, _| quant >= min_order }
                           .last # [<min_order>, <price>].last
  end
end

# pricing_rules/buy_x_get_one_free.rb
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

@pricing_rules = {
  "VOUCHER" => BuyXGetOneFree.new(5.00, 2),
  "TSHIRT"  => BulkDiscount.new(20.00, {3 => 19.0}),
  "MUG"     => StandardPrice.new(7.50),
}

@c = Checkout.new(@pricing_rules)
@c.scan("VOUCHER")
@c.scan("MUG")
@c.scan("TSHIRT")
@c.scan("TSHIRT")
@c.scan("MUG")
@c.scan("VOUCHER")
