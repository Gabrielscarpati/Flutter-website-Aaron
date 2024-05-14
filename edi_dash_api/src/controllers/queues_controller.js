const {
  select
} = require("../databases/bd_controller");

class QueuesController {
  async selectAll() {
    const result = await select("queue.begin_dte, queue.parent_id, queue.task, q2.id, queue.start, q2.end", "queue")
      .innerJoin("queue q2", "queue.parent_id = q2.id")
      .where("queue.ukey = 60 and queue.start is not null")
      .orderBy("queue.start asc")
      .execute();
    return result;
  }
}

module.exports = QueuesController;