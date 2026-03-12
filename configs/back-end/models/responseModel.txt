/**
 * Interface representing a standard API response
 * @template T - The type of the data property
 */
interface ApiResponse<T> {
    status?: string;
    data?: T;
    message?: string;
    error?: object;
    code?: string;
    count?: number;
    success?: boolean;
    timestamp?: string;
}

/**
 * Creates a success response object
 * @param data - The data to include in a response
 * @param message - A message providing additional information about the response
 * @returns
 */
export const successResponse = <T>(
    data: T,
    message?: string,
    count?: number
): ApiResponse<T> => ({
    message,
    count,
    data,
});

/**
 * Creates an error response object
 * @param message - The error message
 * @param code - Error code for debugging
 * @returns
 */
export const errorResponse = (
    message: string,
    code: string
): ApiResponse<null> => ({
    success: false,
    error: {
        message,
        code,
    },
    timestamp: new Date().toISOString()
});
