const {
  select
} = require("../databases/bd_controller");

class BuyersController {
  async selectAll(sellerId) {
    if (sellerId) {
      return await select('*', 'buyer').where(`seller_id = ${sellerId}`).execute();
    }

    return await select("*", "buyer").execute();
  }
}

module.exports = BuyersController;