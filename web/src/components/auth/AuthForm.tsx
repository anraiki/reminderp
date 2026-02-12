import { useAuthActions } from "@convex-dev/auth/react";
import { useState } from "react";
import { Box, Button, Heading, Input, Stack, Text } from "@chakra-ui/react";
import { toaster } from "../ui/toaster";

export function AuthForm() {
  const { signIn } = useAuthActions();
  const [flow, setFlow] = useState<"signIn" | "signUp">("signIn");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    try {
      await signIn("password", { email, password, flow });
    } catch (err) {
      toaster.create({
        title: flow === "signIn" ? "Sign in failed" : "Sign up failed",
        description:
          err instanceof Error ? err.message : "Something went wrong",
        type: "error",
      });
    } finally {
      setLoading(false);
    }
  };

  return (
    <Box bg="#2D3748" p="8" borderRadius="lg" w="full" maxW="400px">
      <form onSubmit={handleSubmit}>
        <Stack gap="4">
          <Heading size="lg" color="#E2E8F0" textAlign="center">
            {flow === "signIn" ? "Sign In" : "Sign Up"}
          </Heading>
          <Input
            placeholder="Email"
            type="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            bg="#1A202C"
            borderColor="#4A5568"
            color="#E2E8F0"
            required
          />
          <Input
            placeholder="Password"
            type="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            bg="#1A202C"
            borderColor="#4A5568"
            color="#E2E8F0"
            required
          />
          <Button
            type="submit"
            bg="#319795"
            color="white"
            loading={loading}
            w="full"
          >
            {flow === "signIn" ? "Sign In" : "Sign Up"}
          </Button>
          <Text
            textAlign="center"
            fontSize="sm"
            color="#A0AEC0"
            cursor="pointer"
            onClick={() => setFlow(flow === "signIn" ? "signUp" : "signIn")}
          >
            {flow === "signIn"
              ? "Don't have an account? Sign up"
              : "Already have an account? Sign in"}
          </Text>
        </Stack>
      </form>
    </Box>
  );
}
