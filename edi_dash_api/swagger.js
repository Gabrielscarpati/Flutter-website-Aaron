const swaggerAutogen = require('swagger-autogen')();

const doc = {
  info: {
    title: 'API Documentation',
    description: 'Comprehensive API Reference and Interactive Testing',
  },
  host: 'localhost:5050',
  schemes: ['http'],
};

const outputFile = './swagger_output.json';
const endpointsFiles = ['./app.js']; // Coloque aqui o caminho para o arquivo que contém suas rotas

swaggerAutogen(outputFile, endpointsFiles, doc);
