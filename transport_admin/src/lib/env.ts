import { z } from "zod";

const schema = z.object({
  DATABASE_URL: z.string().min(1),
  JWT_STAFF_SECRET: z.string().min(32),
  JWT_PASSENGER_SECRET: z.string().min(32),
});

// Next.js loads .env.local into process.env automatically.
export const env = schema.parse(process.env);