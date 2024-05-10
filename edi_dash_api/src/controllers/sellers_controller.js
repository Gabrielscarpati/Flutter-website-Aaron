const { select } = require("../databases/bd_controller");

class SellersController {
  async selectAll() {
    const result = await select("*", "seller").execute();
    return result;
  }
}

module.exports = SellersController;