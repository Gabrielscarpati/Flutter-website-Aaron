require('dotenv').config();

const express = require('express');
const session = require('express-session');
const path = require('path');
const mysql = require('mysql');
const bodyParser = require('body-parser');

const app = express();
const port = process.env.SERVER_PORT;

var passport = require('passport');
// const LocalStrategy = require('passport-local').Strategy;

const connection = mysql.createConnection({
    host: process.env.HOST,
    user: process.env.USER,
    port: process.env.DB_PORT,
    password: process.env.PASSWORD,
    database: process.env.DATABASE
});

app.use(bodyParser.urlencoded({
    extended: true
}));
app.use(bodyParser.json({
    extended: true
}));
app.use(express.static(path.join(__dirname, 'public')));

// Configurar o express-session
app.use(session({
    secret: 'secreto', // Chave secreta para assinar a sessão
    resave: false,
    saveUninitialized: false
}));

// Middleware de inicialização do passport
app.use(passport.initialize());

// Middleware de persistência de sessão
app.use(passport.session());

// Middleware para adicionar erros de autenticação e o usuário atual ao objeto res.locals
app.use((req, res, next) => {
    res.locals.user = req.user;
    next();
});

app.get('/', async (_, res) => {
    try {
        connection.query('select * from admin', function (error, results, _fields) {
            if (error) {
                res.json({
                    error
                });
            } else {
                res.json(results);
            }
        });
    } catch (error) {
        res.json({
            error
        });
    }
});

app.get('/sellers', async (_, res) => {
    try {
        connection.query('select * from seller', function (error, results, _fields) {
            if (error) {
                res.json({
                    error
                });
            } else {
                res.json(results);
            }
        });
    } catch (error) {
        res.json({
            error
        });
    }
});

app.listen(port, () => {
    console.log(`http://localhost:${port}/`);
});