import express from 'express'
import * as Connect from './connect.js'
var cors = require("cors")
var app = express();

app.use(express.json())
app.use(cors())

app.get("/allusers", async function (req, res) {
    const call = async () => {
        await Connect.conn.connect();
        var sqlString = "select * from Users"
        const request = new Connect.sql.Request(Connect.conn);
        var result = await request.query(sqlString);
        return result.recordset;
    }
    try {
        const result = await call();
        res.json(result);

    } catch (error) {
        res.status(500).json({ error: 'An error occurred while retrieving the users.' });
    }
})
app.get("/allcourses", async function (req, res) {
    const call = async () => {
        await Connect.conn.connect();
        var sqlString = "select * from Courses"
        const request = new Connect.sql.Request(Connect.conn);
        var result = await request.query(sqlString);
        return result.recordset;
    }
    try {
        const result = await call();
        res.json(result);

    } catch (error) {
        res.status(500).json({ error: 'An error occurred while retrieving the users.' });
    }
})
app.get("/allteacher/", async function (req, res) {
    const call = async () => {
        await Connect.conn.connect();
        let result = await Connect.conn.request()
            .input('param', Connect.sql.Int, null)
            .execute('teacherOfCourse')

        return result
    }
    try {
        const result = await call();

        res.json(result.recordset);

    } catch (error) {
        console.log(error)
        res.status(500).json({ error: 'An error occurred while retrieving the users.' });
    }

})

app.get("/allteacher/:courseID", async function (req, res) {
    const ID = req.params.courseID
    const call = async () => {
        await Connect.conn.connect();
        let result = await Connect.conn.request()
            .input('param', Connect.sql.Int, ID)
            .execute('teacherOfCourse')
        console.dir(result.recordset)
        return result
    }
    try {
        const result = await call();
        console.dir(result.recordset)
        res.json(result.recordset);

    } catch (error) {
        console.log(error)
        res.status(500).json({ error: 'An error occurred while retrieving the users.' });
    }

})

app.get("/infoteacher/:ID", async function (req, res) {
    const ID = req.params.ID
    const call = async () => {
        await Connect.conn.connect();
        let result = await Connect.conn.request()
            .input('param', Connect.sql.Int, ID)
            .execute('infoOfTeacher')
        console.dir(result.recordset)
        return result
    }
    try {
        const result = await call();
        console.dir(result.recordset)
        res.json(result.recordset);

    } catch (error) {
        console.log(error)
        res.status(500).json({ error: 'An error occurred while retrieving the users.' });
    }

})



app.listen(3005, function () {
    console.log(
        '🚀 Server ready at: http://localhost:3000',
    )
});