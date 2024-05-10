require('dotenv').config();

const express = require('express');
const session = require('express-session');
const path = require('path');
const mysql = require('mysql');
const bodyParser = require('body-parser');
const cors = require('cors');

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

app.use(cors({origin: "*"}));

app.get('/edi_members', async (_, res) => {
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

app.get('/edi_customers', async (_, res) => {
    try {
        connection.query('select * from buyer', function (error, results, _fields) {
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

app.get('/american_flooring', async (_, res) => {
    try {
        connection.query(`
        select queue.parent_id, queue.task, q2.id, queue.start, q2.end 
        from queue inner join queue q2 on queue.parent_id = q2.id
        where queue.ukey = 60 and queue.start is not null
        order by queue.start asc`,
            function (error, results, _fields) {
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

app.get('/warnings', async (_, res) => {
    try {
        connection.query('select * from log where category = "Error"', function (error, results, _fields) {
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