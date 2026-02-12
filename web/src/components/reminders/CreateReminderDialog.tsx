import { useMutation, useQuery } from "convex/react";
import { api } from "convex/_generated/api";
import { useState } from "react";
import {
  Box,
  Button,
  Flex,
  Heading,
  Input,
  Stack,
  Text,
} from "@chakra-ui/react";
import { format } from "date-fns";

interface CreateReminderDialogProps {
  open: boolean;
  onClose: () => void;
  defaultDate: Date;
}

export function CreateReminderDialog({
  open,
  onClose,
  defaultDate,
}: CreateReminderDialogProps) {
  const createTrigger = useMutation(api.triggers.create);
  const createReminder = useMutation(api.reminders.create);
  const lists = useQuery(api.reminderLists.listByUser) ?? [];

  const [body, setBody] = useState("");
  const [date, setDate] = useState(format(defaultDate, "yyyy-MM-dd"));
  const [time, setTime] = useState("09:00");
  const [every, setEvery] = useState("");
  const [selectedListId, setSelectedListId] = useState("");
  const [loading, setLoading] = useState(false);

  if (!open) return null;

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);

    try {
      const dateTime = new Date(`${date}T${time}`);

      const triggerId = await createTrigger({
        at: dateTime.getTime(),
        every: every || undefined,
      });

      await createReminder({
        body: body || undefined,
        triggerId,
        listId: (selectedListId || undefined) as any,
        overrides: [],
      });

      setBody("");
      setEvery("");
      setSelectedListId("");
      onClose();
    } catch (err) {
      console.error("Failed to create reminder:", err);
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
      <Box bg="#2D3748" borderRadius="lg" p="6" w="full" maxW="450px">
        <form onSubmit={handleSubmit}>
          <Stack gap="4">
            <Heading size="md" color="#E2E8F0">
              New Reminder
            </Heading>

            <Box>
              <Text fontSize="sm" color="#A0AEC0" mb="1">
                What to remember
              </Text>
              <Input
                value={body}
                onChange={(e) => setBody(e.target.value)}
                placeholder="Reminder text..."
                bg="#1A202C"
                borderColor="#4A5568"
                color="#E2E8F0"
              />
            </Box>

            <Flex gap="3">
              <Box flex="1">
                <Text fontSize="sm" color="#A0AEC0" mb="1">
                  Date
                </Text>
                <Input
                  type="date"
                  value={date}
                  onChange={(e) => setDate(e.target.value)}
                  bg="#1A202C"
                  borderColor="#4A5568"
                  color="#E2E8F0"
                />
              </Box>
              <Box flex="1">
                <Text fontSize="sm" color="#A0AEC0" mb="1">
                  Time
                </Text>
                <Input
                  type="time"
                  value={time}
                  onChange={(e) => setTime(e.target.value)}
                  bg="#1A202C"
                  borderColor="#4A5568"
                  color="#E2E8F0"
                />
              </Box>
            </Flex>

            <Box>
              <Text fontSize="sm" color="#A0AEC0" mb="1">
                Repeat
              </Text>
              <Flex gap="2" flexWrap="wrap">
                {["", "daily", "weekly", "monthly"].map((opt) => (
                  <Button
                    key={opt}
                    size="sm"
                    variant={every === opt ? "solid" : "outline"}
                    bg={every === opt ? "#319795" : undefined}
                    borderColor="#4A5568"
                    color={every === opt ? "white" : "#E2E8F0"}
                    onClick={() => setEvery(opt)}
                    type="button"
                  >
                    {opt || "Once"}
                  </Button>
                ))}
              </Flex>
            </Box>

            {lists.length > 0 && (
              <Box>
                <Text fontSize="sm" color="#A0AEC0" mb="1">
                  List
                </Text>
                <Flex gap="2" flexWrap="wrap">
                  <Button
                    size="sm"
                    variant={selectedListId === "" ? "solid" : "outline"}
                    bg={selectedListId === "" ? "#319795" : undefined}
                    borderColor="#4A5568"
                    color={selectedListId === "" ? "white" : "#E2E8F0"}
                    onClick={() => setSelectedListId("")}
                    type="button"
                  >
                    None
                  </Button>
                  {lists.map((list) => (
                    <Button
                      key={list._id}
                      size="sm"
                      variant={
                        selectedListId === list._id ? "solid" : "outline"
                      }
                      bg={selectedListId === list._id ? "#319795" : undefined}
                      borderColor="#4A5568"
                      color={
                        selectedListId === list._id ? "white" : "#E2E8F0"
                      }
                      onClick={() => setSelectedListId(list._id)}
                      type="button"
                    >
                      {list.name}
                    </Button>
                  ))}
                </Flex>
              </Box>
            )}

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
                Create
              </Button>
            </Flex>
          </Stack>
        </form>
      </Box>
    </Box>
  );
}
