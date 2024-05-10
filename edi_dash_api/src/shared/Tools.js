
const jwt = require("jsonwebtoken");
const config = require('../../config.json');

class Tools {
  static removerCaracteres(str) {
    var text = str;
    text = text.toLowerCase();
    text = text.replace(new RegExp('[ÁÀÂÃ]', 'gi'), 'a');
    text = text.replace(new RegExp('[ÉÈÊ]', 'gi'), 'e');
    text = text.replace(new RegExp('[ÍÌÎ]', 'gi'), 'i');
    text = text.replace(new RegExp('[ÓÒÔÕ]', 'gi'), 'o');
    text = text.replace(new RegExp('[ÚÙÛ]', 'gi'), 'u');
    text = text.replace(new RegExp('[Ç]', 'gi'), 'c');
    return text.toLowerCase();
  }

  static equalsObject(object1, object2) {
    const keys1 = Object.keys(object1);
    const keys2 = Object.keys(object2);

    if (keys1.length !== keys2.length) {
      return false;
    }

    for (let key of keys1) {
      if (object1[key] !== object2[key]) {
        return false;
      }
    }

    return true;
  }



  static verifyJWTRefresh(req, res, next) {
    const token = req.headers['x-access-token'];
    if (!token) return res.status(403).json({ auth: false, message: 'Invalid Token' });
    const decoded = jwt.decode(token)
    req.user = decoded.user;
    next();


  }
  static verifyJWT(req, res, next) {
    var secret = config.secret;
    const token = req.headers['x-access-token'];
    if (!token) return res.status(403).json({ auth: false, message: 'Invalid Token' });

    jwt.verify(token, secret, function (err, decoded) {
      if (err) return res.status(401).json({ auth: false, message: 'Failed to autenticate' });
      req.user = decoded.user;
      next();
    });
  }

  static async bodyDefault(req, res, request) {
    res.setHeader("Content-Type", "application/json");
    try {
      const response = await request(req, res);
      return res.json({
        response: response,
        date: new Date().toGMTString(),
        version: "1.0.1"
      });
    } catch (err) {
      if (err.name === 'UnauthorizedError') {
        return res.status(401).json({ message: 'Invalid Token' });
      }
      return res.status(400).send({
        message: err.message
      });
    }
  }
}
module.exports = Tools;