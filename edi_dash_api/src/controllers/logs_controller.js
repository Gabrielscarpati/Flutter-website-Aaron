const {
  select
} = require("../databases/bd_controller");

class LogsController {
  async selectAll(queueId) {
    if (queueId) {
      return await select("*", "log")
        .where(`task_id = ${queueId} and category = 'Error'`)
        .execute();
    }

    return await select("*", "log").where("category = 'Error'").execute();
  }
}

module.exports = LogsController;