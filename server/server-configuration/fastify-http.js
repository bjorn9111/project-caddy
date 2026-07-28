import { createApp } from "../src/app.js";

const app = createApp();

const start = async () => {
  try {
    await app.listen({
      host: "0.0.0.0",
      port: 3000
    });

    app.log.info("Server listening on http://0.0.0.0:3000");
  } catch (err) {
    app.log.error(err);
    process.exit(1);
  }
};

const shutdown = async (signal) => {
  app.log.info(`${signal} received, shutting down...`);

  try {
    await app.close();
    process.exit(0);
  } catch (err) {
    app.log.error(err);
    process.exit(1);
  }
};

process.on("SIGINT", () => shutdown("SIGINT"));   // Ctrl+C
process.on("SIGTERM", () => shutdown("SIGTERM")); // VM/service stop

start();
