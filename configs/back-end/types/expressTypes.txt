import { Request, Response, NextFunction } from "express";

/**
 * Middleware function utilized by next().
 */
export type MiddlewareFunction = (
    req: Request,
    res: Response,
    next: NextFunction
) => void;
