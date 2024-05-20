const {
  select
} = require("../databases/bd_controller");

class QueuesController {
  async selectAll(sellerId) {
    if (sellerId) {
      return await select("queue.exp_dte, queue.id, queue.task, buyer.id as buyer_id, buyer.name as buyer_name, queue.sandbox", "queue")
        .join("buyer", "buyer.id = queue.ukey")
        .where(`queue.seller_id = ${sellerId}`)
        .orderBy("queue.exp_dte desc")
        .execute();
    }

    return await select("seller.name as seller_name, queue.exp_dte, queue.id, queue.task, buyer.id as buyer_id, buyer.name as buyer_name, queue.sandbox", "queue")
      .join("seller", "seller.id = queue.seller_id")
      .join("buyer", "buyer.id = queue.ukey")
      .orderBy("queue.exp_dte desc")
      .execute();
  }
}

module.exports = QueuesController;