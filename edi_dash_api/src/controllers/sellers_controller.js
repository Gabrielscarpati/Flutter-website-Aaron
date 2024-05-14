const {
  select
} = require("../databases/bd_controller");

class SellersController {
  async selectAll(id) {
    if (id) {
      return await select('*', 'seller').where(`id = ${id}`).execute()
    }

    return await select('*', 'seller').execute();
  }

  async selectSellerDetails() {
    const result =
      await select(`seller.name, seller.phone, seller.state, 
      (select count(1) from buyer as b1 where seller.id = b1.seller_id and b1.active = 1) as trading_partners, 
      (select count(1) from buyer where seller.id = buyer.seller_id and buyer.active != 1) as removed`, 'seller').where('seller.ignoreTLS != 1')
      .execute();
    return result;
  }
}

module.exports = SellersController;