const mysql = require('mysql');
const util = require('util');
const dotenv = require('dotenv');
dotenv.config();

const pool = mysql.createPool({
  connectionLimit: 10,  // O número de conexões máximas que o pool pode ter
  host: process.env.HOST,
  user: process.env.USER_DB,
  port: process.env.DB_PORT,
  password: process.env.PASSWORD,
  database: process.env.DATABASE
});

pool.query = util.promisify(pool.query);

pool.on('connection', function (connection) {
  console.log('DB Connection established');
});

pool.on('error', function (err) {
  console.error('DB error', err);
  if (err.code === 'PROTOCOL_CONNECTION_LOST') {
    console.error('DB connection was closed.');
  } else {
    throw err;
  }
});

// Função para execução de consultas genéricas
const querySQL = async (text, params) => {
  try {
    const result = await pool.query(text, params);
    return result;
  } catch (error) {
    console.error('Query error', error);
    throw error;
  }
};

// Restante do seu código...

class QueryBuilder {
  constructor(table) {
    this.table = table;
    this.queryParts = [];
    this.params = [];
  }

  where(condition) {
    this.queryParts.push(`WHERE ${condition}`);
    return this;
  }
  orderBy(condition) {
    this.queryParts.push(`order by ${condition}`);
    return this;
  }

  select(filter) {
    this.queryParts.push(`SELECT ${filter} FROM ${this.table}`);
    return this;
  }

  update() {
    this.queryParts.push(`UPDATE ${this.table} SET`);
    return this;
  }

  delete() {
    this.queryParts.push(`DELETE FROM ${this.table}`);
    return this;
  }

  insert() {
    this.queryParts.push(`INSERT INTO ${this.table}`);
    return this;
  }

  #objectToString(obj) {
    return Object.entries(obj).map(([key, value]) => {
      if (typeof value === 'string') {
        return `${key}='${value}'`; // Aspas para strings
      } else {
        return `${key}=${value}`; // Sem aspas para não-strings
      }
    }).join(', ');
  }
  set(fields) {
    const columns = this.#objectToString(fields)
    this.queryParts.push(columns);
    return this;
  }

  values(fields) {
    const columns = Object.keys(fields).join(', ');
    const values = Object.values(fields).map((value, index) => `?`);
    this.queryParts.push(`(${columns}) VALUES (${values})`);
    this.params.push(...Object.values(fields));
    return this;
  }

  join(table, condition) {
    this.queryParts.push(`JOIN ${table} ON ${condition}`);
    return this;
  }

  innerJoin(table, condition) {
    this.queryParts.push(`INNER JOIN ${table} ON ${condition}`);
    return this;
  }

  leftJoin(table, condition) {
    this.queryParts.push(`LEFT JOIN ${table} ON ${condition}`);
    return this;
  }

  rightJoin(table, condition) {
    this.queryParts.push(`RIGHT JOIN ${table} ON ${condition}`);
    return this;
  }

  count() {
    this.queryParts.unshift('SELECT COUNT(*) FROM');
    return this;
  }

  subquery(subqueryAlias, subquery) {
    this.queryParts.push(`(${subquery}) AS ${subqueryAlias}`);
    return this;
  }

  async execute() {
    const query = `${this.queryParts.join(' ')};`;
    const result = await querySQL(query, this.params);
    return result;
  }
}

// Funções de conveniência para facilitar a criação de consultas
const select = (filter, table) => {
  return new QueryBuilder(table).select(filter);
};

const update = (table) => {
  return new QueryBuilder(table).update();
};

const remove = (table) => {
  return new QueryBuilder(table).delete();
};

const insert = (table) => {
  return new QueryBuilder(table).insert();
};

module.exports = {
  querySQL,
  select,
  update,
  remove,
  insert
};