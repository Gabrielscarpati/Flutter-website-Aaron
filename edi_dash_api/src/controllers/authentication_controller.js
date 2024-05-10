const jwt = require("jsonwebtoken");
const randtoken = require("rand-token");
const config = require('../../config.json');
const UserController = require("./user_controller");
var refreshTokens = {}
var secret = config.secret;


const userController = new UserController();

class AuthenticationController {

  gerarToken(user, email) {
    const token = jwt.sign({ user }, secret, { expiresIn: 10 });
    const refreshToken = randtoken.uid(256);
    refreshTokens[email] = refreshToken;
    return { token, refreshToken };
  }

  async login({
    email_user,
    password
  }) {
    const user = await userController.findByEmailAndPassword(email_user, password);
    if (!user[0]) {
      throw new Error("User not found");
    }
    const firstUser = user[0]
    const { token, refreshToken } = this.gerarToken(firstUser, email_user);
    return {
      token,
      refreshToken,
      "user": firstUser,
    };
  }

  async register({
    email_user,
    password,
    seller_id
  }) {
    await userController.registerByEmailAndPassword(email_user, password, seller_id);
    return await this.login({
      email_user,
      password
    });
  }


  async refreshToken({
    user,
    refreshToken
  }) {
    const email = user.email;
    console.log(refreshTokens)
    if ((email in refreshTokens) && (refreshTokens[email] == refreshToken)) {
      return this.gerarToken(user, email);
    }
    throw new Error('Token inválido');
  }

}
module.exports = AuthenticationController;