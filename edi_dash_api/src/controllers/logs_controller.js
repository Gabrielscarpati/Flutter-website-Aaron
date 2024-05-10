const { select } = require("../databases/bd_controller");

class LogsController {
  async selectErrors() {
    const result = await select("*", "log")
      .where("category = 'Error'")
      .execute();
    return result;
  }
}

module.exports = LogsController;