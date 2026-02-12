import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import { TanStackRouterVite } from "@tanstack/router-plugin/vite";
import path from "path";

export default defineConfig({
  plugins: [TanStackRouterVite(), react()],
  resolve: {
    alias: {
      "convex/_generated": path.resolve(
        __dirname,
        "../backend/convex/_generated"
      ),
    },
    // Ensure imports from the backend _generated files resolve
    // convex/server etc. from the web's node_modules
    dedupe: ["convex", "react", "react-dom"],
  },
});
