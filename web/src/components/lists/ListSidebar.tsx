import { useQuery, useMutation } from "convex/react";
import { useAuthActions } from "@convex-dev/auth/react";
import { api } from "convex/_generated/api";
import { useState } from "react";
import {
  Box,
  Button,
  Flex,
  Heading,
  IconButton,
  Stack,
  Text,
} from "@chakra-ui/react";
import {
  MdAdd,
  MdDelete,
  MdEdit,
  MdLogout,
  MdViewList,
} from "react-icons/md";
import { getIcon } from "../../lib/iconMap";
import { CreateListDialog } from "./CreateListDialog";

export function ListSidebar() {
  const lists = useQuery(api.reminderLists.listByUser) ?? [];
  const removeList = useMutation(api.reminderLists.remove);
  const { signOut } = useAuthActions();
  const [showCreate, setShowCreate] = useState(false);
  const [editingList, setEditingList] = useState<{
    id: string;
    name: string;
    iconName: string;
  } | null>(null);

  return (
    <Box
      w="260px"
      bg="#2D3748"
      h="full"
      p="4"
      display="flex"
      flexDirection="column"
      borderRight="1px solid"
      borderColor="#4A5568"
    >
      <Heading size="md" mb="4" color="#E2E8F0">
        Reminderp
      </Heading>

      <Stack gap="1" flex="1" overflowY="auto">
        <Flex
          align="center"
          gap="2"
          px="3"
          py="2"
          borderRadius="md"
          bg="rgba(49, 151, 149, 0.15)"
          color="#319795"
          cursor="pointer"
        >
          <MdViewList />
          <Text fontWeight="medium">All Reminders</Text>
        </Flex>

        {lists.map((list) => {
          const Icon = getIcon(list.iconName);
          return (
            <Flex
              key={list._id}
              align="center"
              gap="2"
              px="3"
              py="2"
              borderRadius="md"
              cursor="pointer"
              _hover={{ bg: "rgba(255,255,255,0.05)" }}
              role="group"
            >
              <Icon />
              <Text flex="1">{list.name}</Text>
              <Flex
                gap="0"
                opacity={0}
                _groupHover={{ opacity: 1 }}
                transition="opacity 0.15s"
              >
                <IconButton
                  aria-label="Edit list"
                  size="xs"
                  variant="ghost"
                  color="#A0AEC0"
                  onClick={(e) => {
                    e.stopPropagation();
                    setEditingList({
                      id: list._id,
                      name: list.name,
                      iconName: list.iconName,
                    });
                  }}
                >
                  <MdEdit />
                </IconButton>
                <IconButton
                  aria-label="Delete list"
                  size="xs"
                  variant="ghost"
                  color="#FC8181"
                  onClick={(e) => {
                    e.stopPropagation();
                    removeList({ id: list._id });
                  }}
                >
                  <MdDelete />
                </IconButton>
              </Flex>
            </Flex>
          );
        })}
      </Stack>

      <Stack gap="2" mt="4">
        <Button
          size="sm"
          variant="outline"
          borderColor="#4A5568"
          color="#E2E8F0"
          onClick={() => setShowCreate(true)}
          w="full"
        >
          <MdAdd />
          New List
        </Button>
        <Button
          size="sm"
          variant="ghost"
          color="#A0AEC0"
          onClick={() => signOut()}
          w="full"
        >
          <MdLogout />
          Sign Out
        </Button>
      </Stack>

      <CreateListDialog
        open={showCreate}
        onClose={() => setShowCreate(false)}
      />

      {editingList && (
        <CreateListDialog
          open={true}
          onClose={() => setEditingList(null)}
          editId={editingList.id}
          initialName={editingList.name}
          initialIcon={editingList.iconName}
        />
      )}
    </Box>
  );
}
