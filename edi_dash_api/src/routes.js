const {
  Router
} = require("express");
const Tools = require("./shared/Tools");
const SellersController = require("./controllers/sellers_controller");
const BuyersController = require("./controllers/buyers_controller");
const QueuesController = require("./controllers/queues_controller");
const LogsController = require("./controllers/logs_controller");
const AuthenticationController = require("./controllers/authentication_controller");


const sellersController = new SellersController();
const buyersController = new BuyersController();
const queuesController = new QueuesController();
const logsController = new LogsController();
const autenticationController = new AuthenticationController();

const router = Router()
  .get('/', function (_req, res) {
    return res.json({
      response: "ok",
      date: new Date().toGMTString(),
      version: "1.0.2"
    });
  })
  .get('/sellers', Tools.verifyJWT, async function (req, res) {
    return await Tools.bodyDefault(req, res, async function () {
      return await sellersController.selectAll(req.query.id);
    });
  })
  .get('/sellers/details', Tools.verifyJWT, async function (req, res) {
    return await Tools.bodyDefault(req, res, async function () {
      return await sellersController.selectSellerDetails();
    });
  })
  .get('/buyers', Tools.verifyJWT, async function (req, res) {
    return await Tools.bodyDefault(req, res, async function () {
      const result = await buyersController.selectAll(req.query.seller_id);
      return result;
    });
  })
  .post('/login', async function (req, res) {
    return await Tools.bodyDefault(req, res, async function () {
      const {
        email_user,
        password
      } = req.body;

      const result = await autenticationController.login({
        email_user,
        password
      });

      return result;
    });
  })
  .post('/register', async function (req, res) {
    return await Tools.bodyDefault(req, res, async function () {
      const {
        email_user,
        password,
        seller_id
      } = req.body;
      const result = await autenticationController.register({
        email_user,
        password,
        seller_id
      });
      return result;
    });
  })
  .post('/refreshToken', Tools.verifyJWTRefresh, async function (req, res) {
    return await Tools.bodyDefault(req, res, async function () {
      const user = req.user;
      const {
        refreshToken,
      } = req.body;
      const result = await autenticationController.refreshToken({
        user,
        refreshToken
      });
      return result;
    });
  })
  .get('/queues', Tools.verifyJWT, async function (req, res) {
    return await Tools.bodyDefault(req, res, async function () {
      const result = await queuesController.selectAll(req.query.seller_id);
      return result;
    });
  })
  .get('/logs/error', Tools.verifyJWT, async function (req, res) {
    return await Tools.bodyDefault(req, res, async function () {
      const result = await logsController.selectErrors();
      return result;
    });
  });


module.exports = router