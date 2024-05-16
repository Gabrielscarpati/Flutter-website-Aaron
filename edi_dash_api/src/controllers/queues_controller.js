const {
  select
} = require("../databases/bd_controller");

class QueuesController {
  async selectAll(sellerId) {
    if (sellerId) {
      return await select("queue.exp_dte, queue.id, queue.task, queue.sandbox", "queue")
        .where(`queue.seller_id = ${sellerId}`)
        .execute();
    }

    return await select("seller.name, queue.exp_dte, queue.id, queue.task, queue.sandbox", "queue")
      .join("seller", "seller.id = queue.seller_id")
      .orderBy("queue.start asc")
      .execute();
  }
}

module.exports = QueuesController;