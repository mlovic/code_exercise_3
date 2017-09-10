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
