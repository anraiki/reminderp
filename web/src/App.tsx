import { RouterProvider, createRouter } from "@tanstack/react-router";
import { Provider } from "./components/ui/provider";
import { routeTree } from "./routeTree.gen";

const router = createRouter({ routeTree });

declare module "@tanstack/react-router" {
  interface Register {
    router: typeof router;
  }
}

export function App() {
  return (
    <Provider>
      <RouterProvider router={router} />
    </Provider>
  );
}
