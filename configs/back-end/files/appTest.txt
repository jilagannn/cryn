import request, { Response } from "supertest";

import app from "../../src/app";

describe("GET /", () => {
    // "it should do this"
    it("should return 'This is a response to the request' on request", async () => {
        // arrange
        const expectedResponse: string = "This is a response to the request";

        // act
        const response: Response = await request(app).get("/");

        // assert
        expect(response.status).toBe(200);
        expect(response.text).toBe(expectedResponse);
    });
});