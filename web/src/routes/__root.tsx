import {
  createRootRoute,
  Outlet,
  useNavigate,
  useRouterState,
} from "@tanstack/react-router";
import { useConvexAuth } from "convex/react";
import { useEffect } from "react";
import { Box, Flex, Spinner } from "@chakra-ui/react";
import { ListSidebar } from "../components/lists/ListSidebar";

function RootLayout() {
  const { isAuthenticated, isLoading } = useConvexAuth();
  const navigate = useNavigate();
  const pathname = useRouterState({ select: (s) => s.location.pathname });

  useEffect(() => {
    if (!isLoading && !isAuthenticated && pathname !== "/auth") {
      navigate({ to: "/auth" });
    }
  }, [isLoading, isAuthenticated, pathname, navigate]);

  if (isLoading) {
    return (
      <Flex h="100vh" align="center" justify="center" bg="#1A202C">
        <Spinner size="xl" color="#319795" />
      </Flex>
    );
  }

  if (!isAuthenticated && pathname !== "/auth") {
    return null;
  }

  if (pathname === "/auth") {
    return <Outlet />;
  }

  return (
    <Flex h="100vh" bg="#1A202C" color="#E2E8F0">
      <ListSidebar />
      <Box flex="1" overflowY="auto">
        <Outlet />
      </Box>
    </Flex>
  );
}

export const Route = createRootRoute({
  component: RootLayout,
});
