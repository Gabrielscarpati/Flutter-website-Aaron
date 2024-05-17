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

    return await select("log.*, buyer.id as buyer_id, buyer.name as buyer_name", "log")
      .join("queue", "queue.id = log.task_id")
      .join("buyer", "buyer.id = queue.ukey")
      .where("category = 'Error'")
      .execute();
  }
}

module.exports = LogsController;