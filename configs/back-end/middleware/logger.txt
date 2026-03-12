import morgan, { StreamOptions } from "morgan";
import fs from "fs";
import path from "path";
import { MiddlewareFunction } from "../types/expressTypes";

const logsDirectory: string = path.join(__dirname, "../../../logs");

if (!fs.existsSync(logsDirectory)) {
    fs.mkdirSync(logsDirectory, {recursive: true});
};

const accessLogStream: fs.WriteStream = fs.createWriteStream(path.join(logsDirectory, "access.log"), {
    flags: "a"
});

const errorLogStream: StreamOptions = {
    write: (message) =>
        fs.appendFileSync(path.join(logsDirectory, "errors.log"), message)
}

const accessLogger: MiddlewareFunction = morgan("combined", { stream: accessLogStream });

const errorLogger: MiddlewareFunction = morgan("combined", {
    stream: errorLogStream,
    skip: (req, res) => res.statusCode < 400
});

const consoleLogger: MiddlewareFunction = morgan("dev");

export { accessLogger, errorLogger, consoleLogger };
