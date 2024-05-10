const { select } = require("../databases/bd_controller");

class BuyersController {
  async selectAll() {
    const result = await select("*", "buyer").execute();
    return result;
  }
}

module.exports = BuyersController;