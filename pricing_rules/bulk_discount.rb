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
