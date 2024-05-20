const {
  select
} = require("../databases/bd_controller");

class LogsController {
  async selectAll(queueId) {
    if (queueId) {
      return await select("log.*, seller.id as seller_id", "log")
        .where(`log.task_id = ${queueId} and log.category = 'Error'`)
        .join("queue", "queue.id = log.task_id")
        .join("seller", "seller.id = queue.seller_id")
        .orderBy("log.created_at desc")
        .execute();
    }

    return await select("log.*, buyer.id as buyer_id, buyer.name as buyer_name, seller.id as seller_id", "log")
      .join("queue", "queue.id = log.task_id")
      .join("buyer", "buyer.id = queue.ukey")
      .join("seller", "seller.id = queue.seller_id")
      .where("category = 'Error'")
      .orderBy("log.created_at desc")
      .execute();
  }
}

module.exports = LogsController;