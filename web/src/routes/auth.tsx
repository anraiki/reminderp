import { createFileRoute, useNavigate } from "@tanstack/react-router";
import { useConvexAuth } from "convex/react";
import { useEffect } from "react";
import { Flex } from "@chakra-ui/react";
import { AuthForm } from "../components/auth/AuthForm";

function AuthPage() {
  const { isAuthenticated } = useConvexAuth();
  const navigate = useNavigate();

  useEffect(() => {
    if (isAuthenticated) {
      navigate({ to: "/" });
    }
  }, [isAuthenticated, navigate]);

  return (
    <Flex h="100vh" align="center" justify="center" bg="#1A202C">
      <AuthForm />
    </Flex>
  );
}

export const Route = createFileRoute("/auth")({
  component: AuthPage,
});
