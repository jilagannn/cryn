import express, { Express } from "express";
import morgan from "morgan";
import healthRoutes from "../src/api/v1/routes/healthRoutes";

// start express
const app: Express = express();

// configure Morgan
app.use(morgan("combined"));

// middleware parsing for json responses
app.use(express.json());

// basic route
app.get("/", (req, res) => {
    res.send("This is a response to the request");
});

// health route
app.use("/api/v1/health", healthRoutes);

export default app;
