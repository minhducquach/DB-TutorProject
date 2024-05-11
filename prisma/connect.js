import * as sql from 'mssql'

const config = {
    user: 'sa',
    password: '16102002',
    server: 'localhost',
    database: 'ASS_DB_TEST',
    port: 1433,
    driver: 'msnodesqlv8',
    options: {
        trustedConnection: true,
        enableArithAbort: true
    }
};

const connect = new MSSQL.ConnectionPool(config, function (err) {
    if (err) {
        console.log('Error while creating connection pool \n' + err);
    }
})

module.exports = {
    conn: connect,
    sql: sql
}