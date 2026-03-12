import { AuthorizationOptions } from "../models/authorizationOptions";
import { Request, Response, NextFunction } from "express";
import { MiddlewareFunction } from "../types/expressTypes";
import { AuthorizationError } from "../errors/errors";

const isAuthorized = (opts: AuthorizationOptions): MiddlewareFunction => {
    return(req: Request, res: Response, next: NextFunction) => {
        try {
            const { role, uid } = res.locals;
            const { id } = req.params;

            // if user id is included and matches uid then they can go ahead
            if (opts.allowSameUser && id && uid === id) {
                return next();
            };

            if (!role) {
                throw new AuthorizationError(
                    "Forbidden: No role found",
                    "ROLE_NOT_FOUND"
                );
            };

            if (opts.hasRole.includes(role)) {
                return next();
            };

            throw new AuthorizationError(
                "Forbidden: Insufficient role",
                "INSUFFICIENT_ROLE"
            );

        } catch (error) {
            next(error);
        };
    };
};

export default isAuthorized;
