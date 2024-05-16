const {
  select
} = require("../databases/bd_controller");

class QueuesController {
  async selectAll(sellerId) {
    if (sellerId) {
      return await select("queue.exp_dte, q2.id, queue.task, queue.sandbox", "queue")
        .innerJoin("queue q2", "queue.parent_id = q2.id")
        .where(`queue.ukey = 60 and queue.start is not null and queue.seller_id = ${sellerId}`)
        .orderBy("queue.start asc")
        .execute();
    }

    return await select("seller.name, queue.exp_dte, q2.id, queue.task, queue.sandbox", "queue")
      .innerJoin("queue q2", "queue.parent_id = q2.id")
      .join("seller", "seller.id = queue.seller_id")
      .where("queue.ukey = 60 and queue.start is not null")
      .orderBy("queue.start asc")
      .execute();
  }
}

module.exports = QueuesController;