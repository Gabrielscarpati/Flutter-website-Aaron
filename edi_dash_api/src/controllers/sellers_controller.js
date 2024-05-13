const {
  select
} = require("../databases/bd_controller");

class SellersController {
  async selectSales() {
    const result =
      await select(`seller.name, buyer.name as contact_name, seller.phone, (select count(1) from buyer as b where seller.id = b.seller_id and b.active != 1) as removed, seller.state, (select count(1) from buyer as b1 where seller.id = b1.seller_id and b1.active = 1) as trading_partners`, 'seller')
      .join('buyer', 'seller.id = buyer.seller_id')
      .execute();
    return result;
  }
}

module.exports = SellersController;