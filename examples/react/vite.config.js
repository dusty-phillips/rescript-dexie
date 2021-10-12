import { defineConfig } from "vite";
import reactRefresh from "@vitejs/plugin-react-refresh";

export default defineConfig({
  plugins: [reactRefresh({ include: "**/*.mjs", exclude: "/node_modules/" })],
});
