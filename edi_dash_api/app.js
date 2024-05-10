require('dotenv').config();
const express = require('express');
const cors = require('cors');
const http = require('http');
const routes = require( "./src/routes");
const swaggerUi = require('swagger-ui-express');
const swaggerDocument = require('./swagger_output.json');


const app = express();

app.use(express.json());
app.use(cors({
  origin: '*'
}));
app.use(express.urlencoded({ extended: true }));
app.use('/docs', swaggerUi.serve, swaggerUi.setup(swaggerDocument));
const port = process.env.SERVER_PORT;

http.createServer(app).listen(port, () => console.log(`Servidor rodando local na porta ${port}`));


app.use(routes);