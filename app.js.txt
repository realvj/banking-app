const express = require("express");
const bodyParser = require("body-parser");
const sql = require("mssql");

const app = express();
app.use(bodyParser.json());

const dbConfig = {
    user: process.env.DB_USER,
    password: process.env.DB_PASS,
    server: process.env.DB_SERVER,
    database: process.env.DB_NAME,
    options: {
        encrypt: true,
        trustServerCertificate: false
    }
};

app.get("/", (req, res) => {
    res.send(`
        <h2>Create User</h2>
        <form method="POST" action="/register">
            Username: <input name="username" /><br/>
            Password: <input name="password" type="password"/><br/>
            <button type="submit">Submit</button>
        </form>
    `);
});

app.use(express.urlencoded({ extended: true }));

app.post("/register", async (req, res) => {
    const { username, password } = req.body;

    try {
        await sql.connect(dbConfig);
        await sql.query`
            INSERT INTO Users (Username, Password)
            VALUES (${username}, ${password})
        `;
        res.send("User Created Successfully");
    } catch (err) {
        console.error(err);
        res.status(500).send("Error saving user");
    }
});

app.listen(3000, () => {
    console.log("App running on port 3000");
});
