import request, { Response } from "supertest";
import app from "../../src/app";

describe("GET /api/v1/health", () => {
    it("return the server health status", async () => {
        // Arrange
        const expectedResponse: number = 200;
        const expectedStatusMessage: string = "OK";
        const expectedUptime: string = "uptime";
        const expectedTimestamp: string = "timestamp";
        const expectedVersion: string = "1.0.0";

        // Act
        const response: Response = await request(app).get("/api/v1/health");
    
        // Assert
        expect(response.status).toBe(expectedResponse);
        expect(response.body.status).toBe(expectedStatusMessage);
        expect(response.body).toHaveProperty(expectedUptime);
        expect(response.body).toHaveProperty(expectedTimestamp);
        expect(response.body.version).toBe(expectedVersion);
    });
});