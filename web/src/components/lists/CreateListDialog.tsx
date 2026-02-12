import { useMutation } from "convex/react";
import { api } from "convex/_generated/api";
import { useState } from "react";
import {
  Box,
  Button,
  Flex,
  Grid,
  Heading,
  IconButton,
  Input,
  Stack,
  Text,
} from "@chakra-ui/react";
import { iconMap, getIcon } from "../../lib/iconMap";

interface CreateListDialogProps {
  open: boolean;
  onClose: () => void;
  editId?: string;
  initialName?: string;
  initialIcon?: string;
}

export function CreateListDialog({
  open,
  onClose,
  editId,
  initialName = "",
  initialIcon = "list",
}: CreateListDialogProps) {
  const createList = useMutation(api.reminderLists.create);
  const updateList = useMutation(api.reminderLists.update);

  const [name, setName] = useState(initialName);
  const [selectedIcon, setSelectedIcon] = useState(initialIcon);
  const [loading, setLoading] = useState(false);

  if (!open) return null;

  const isEditing = !!editId;

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!name.trim()) return;
    setLoading(true);

    try {
      if (isEditing) {
        await updateList({
          id: editId as any,
          name: name.trim(),
          iconName: selectedIcon,
        });
      } else {
        await createList({ name: name.trim(), iconName: selectedIcon });
      }
      setName("");
      setSelectedIcon("list");
      onClose();
    } catch (err) {
      console.error("Failed to save list:", err);
    } finally {
      setLoading(false);
    }
  };

  return (
    <Box
      position="fixed"
      inset="0"
      bg="blackAlpha.700"
      display="flex"
      alignItems="center"
      justifyContent="center"
      zIndex="modal"
      onClick={(e) => {
        if (e.target === e.currentTarget) onClose();
      }}
    >
      <Box bg="#2D3748" borderRadius="lg" p="6" w="full" maxW="400px">
        <form onSubmit={handleSubmit}>
          <Stack gap="4">
            <Heading size="md" color="#E2E8F0">
              {isEditing ? "Edit List" : "New List"}
            </Heading>

            <Box>
              <Text fontSize="sm" color="#A0AEC0" mb="1">
                Name
              </Text>
              <Input
                value={name}
                onChange={(e) => setName(e.target.value)}
                placeholder="List name..."
                bg="#1A202C"
                borderColor="#4A5568"
                color="#E2E8F0"
                required
                autoFocus
              />
            </Box>

            <Box>
              <Text fontSize="sm" color="#A0AEC0" mb="2">
                Icon
              </Text>
              <Grid
                templateColumns="repeat(5, 1fr)"
                gap="2"
                maxH="200px"
                overflowY="auto"
              >
                {Object.entries(iconMap).map(([iconName, Icon]) => (
                  <IconButton
                    key={iconName}
                    aria-label={iconName}
                    size="lg"
                    variant={selectedIcon === iconName ? "solid" : "outline"}
                    bg={selectedIcon === iconName ? "#319795" : undefined}
                    borderColor="#4A5568"
                    color={selectedIcon === iconName ? "white" : "#E2E8F0"}
                    onClick={() => setSelectedIcon(iconName)}
                    type="button"
                  >
                    <Icon />
                  </IconButton>
                ))}
              </Grid>
            </Box>

            <Flex gap="3" justify="flex-end" pt="2">
              <Button
                variant="ghost"
                color="#A0AEC0"
                onClick={onClose}
                type="button"
              >
                Cancel
              </Button>
              <Button
                type="submit"
                bg="#319795"
                color="white"
                loading={loading}
              >
                {isEditing ? "Save" : "Create"}
              </Button>
            </Flex>
          </Stack>
        </form>
      </Box>
    </Box>
  );
}
