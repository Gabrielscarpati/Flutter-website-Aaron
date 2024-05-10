const { select, insert } = require("../databases/bd_controller");

class UserController {
  // RowDataPacket {
  //   id: 1,
  //   email: 'teste@teste.com',
  //   password: '123',
  //   seller_id: 1
  // }
  async selectAll() {
    const result = await select("*", "users").execute();
    return result;
  }

  async findByEmailAndPassword(email, password) {
    const result = await select("email, seller_id, id", "users")
      .where(`email = '${email}' AND password = '${password}'`)
      .execute();
    console.log(result)
    return result
  }

  async registerByEmailAndPassword(email, password, seller_id) {
    const userFinded = await select("email, seller_id, id", "users")
      .where(`email = '${email}'`)
      .execute();
    if (userFinded[0]) {
      throw new Error("User mail existed")
    }
    await insert("users").values({
      email,
      password,
      seller_id
    }).execute()
  }
}


module.exports = UserController;