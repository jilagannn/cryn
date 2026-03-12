import { Request, Response, NextFunction } from "express";
import { DecodedIdToken } from "firebase-admin/auth";
import { AuthenticationError } from "../errors/errors";
// import { getErrorMessage, getErrorCode } from "../utils/errorUtils";

import { auth } from "../../../../config/firebaseConfig";


const authenticate = async(
    req: Request,
    res: Response,
    next: NextFunction
): Promise<void> => {
    try {
        // get auth header from req
        const authHeader: string | undefined = req.headers.authorization;
        const token: string | undefined = authHeader?.startsWith("Bearer") ? authHeader.split(" ")[1] : undefined;
    
        if(!token) {
            next(
                new AuthenticationError(
                    "Unauthorized: No token provided",
                    "TOKEN_NOT_FOUND"
                )
            );
        } else {
            const decodedToken: DecodedIdToken = await auth.verifyIdToken(token);
            res.locals.uid = decodedToken.uid;
            res.locals.role = decodedToken.role;
            next();
        };
    } catch (error: unknown) {
        if (error instanceof AuthenticationError) {
            next(error);
        } else {
            next(
                new AuthenticationError(
                    "Unauthorized: Invalid token",
                    "TOKEN_INVALID"
                )
            );
        };
    };
};

export default authenticate;
