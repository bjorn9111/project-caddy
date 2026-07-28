import Fastify from "fastify";
import BOOKS_DATA from './books.json' with { type: 'json' };

export function createApp(options = {}) {
  const app = Fastify({
    logger: true,
    ...options
  });

  app.get("/hello", async () => {
    return {
      message: "Hello World"
    };
  });

  app.get("/", async (req, res, next) => {
    res.send(BOOKS_DATA);
  });
  return app;
}
