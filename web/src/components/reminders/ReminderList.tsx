import { useQuery, useMutation } from "convex/react";
import { api } from "convex/_generated/api";
import { isSameDay, format } from "date-fns";
import { useMemo, useState } from "react";
import {
  Box,
  Button,
  Flex,
  Heading,
  IconButton,
  Text,
  Stack,
} from "@chakra-ui/react";
import { MdDelete, MdAdd, MdEdit } from "react-icons/md";
import { CreateReminderDialog } from "./CreateReminderDialog";

interface ReminderListProps {
  selectedDate: Date;
  listId?: string;
}

export function ReminderList({ selectedDate, listId }: ReminderListProps) {
  const reminders = useQuery(api.reminders.listByUser) ?? [];
  const triggers = useQuery(api.triggers.listByUser) ?? [];
  const lists = useQuery(api.reminderLists.listByUser) ?? [];
  const removeReminder = useMutation(api.reminders.remove);
  const removeTrigger = useMutation(api.triggers.remove);
  const [showCreate, setShowCreate] = useState(false);
  const [editingReminderId, setEditingReminderId] = useState<string | null>(null);

  const triggerMap = useMemo(
    () => new Map(triggers.map((t) => [t._id, t])),
    [triggers]
  );
  const listMap = useMemo(
    () => new Map(lists.map((l) => [l._id, l])),
    [lists]
  );

  const filteredReminders = useMemo(() => {
    return reminders.filter((r) => {
      if (listId && r.listId !== listId) return false;
      if (r.triggerId) {
        const trigger = triggerMap.get(r.triggerId);
        if (trigger) {
          return isSameDay(new Date(trigger.at), selectedDate);
        }
      }
      return isSameDay(new Date(r.createdAt), selectedDate);
    });
  }, [reminders, triggerMap, selectedDate, listId]);

  const editingReminder =
    editingReminderId != null
      ? reminders.find((r) => r._id === editingReminderId) ?? null
      : null;

  const editingTrigger =
    editingReminder?.triggerId != null
      ? triggerMap.get(editingReminder.triggerId) ?? null
      : null;

  const handleDelete = async (reminderId: string, triggerId?: string) => {
    await removeReminder({ id: reminderId as any });
    if (triggerId) {
      await removeTrigger({ id: triggerId as any });
    }
  };

  return (
    <Box>
      <Flex justify="space-between" align="center" mb="4">
        <Heading size="md">{format(selectedDate, "EEEE, MMMM d")}</Heading>
        <Button
          size="sm"
          bg="#319795"
          color="white"
          onClick={() => setShowCreate(true)}
        >
          <MdAdd />
          New Reminder
        </Button>
      </Flex>

      {filteredReminders.length === 0 ? (
        <Text color="#A0AEC0" textAlign="center" py="8">
          No reminders for this day
        </Text>
      ) : (
        <Stack gap="2">
          {filteredReminders.map((reminder) => {
            const trigger = reminder.triggerId
              ? triggerMap.get(reminder.triggerId)
              : null;
            const list = reminder.listId
              ? listMap.get(reminder.listId)
              : null;

            return (
              <Flex
                key={reminder._id}
                bg="#2D3748"
                p="4"
                borderRadius="lg"
                align="center"
                gap="3"
              >
                <Box flex="1">
                  <Text fontWeight="medium">
                    {reminder.body || "Untitled reminder"}
                  </Text>
                  <Flex gap="3" mt="1">
                    {trigger && (
                      <Text fontSize="sm" color="#A0AEC0">
                        {format(new Date(trigger.at), "h:mm a")}
                      </Text>
                    )}
                    {list && (
                      <Text fontSize="sm" color="#805AD5">
                        {list.name}
                      </Text>
                    )}
                    {trigger?.every && (
                      <Text fontSize="sm" color="#48BB78">
                        {trigger.every}
                      </Text>
                    )}
                  </Flex>
                </Box>
                <IconButton
                  aria-label="Edit reminder"
                  size="sm"
                  variant="ghost"
                  color="#A0AEC0"
                  onClick={() => setEditingReminderId(reminder._id)}
                >
                  <MdEdit />
                </IconButton>
                <IconButton
                  aria-label="Delete reminder"
                  size="sm"
                  variant="ghost"
                  color="#FC8181"
                  onClick={() =>
                    handleDelete(reminder._id, reminder.triggerId ?? undefined)
                  }
                >
                  <MdDelete />
                </IconButton>
              </Flex>
            );
          })}
        </Stack>
      )}

      <CreateReminderDialog
        open={showCreate}
        onClose={() => setShowCreate(false)}
        defaultDate={selectedDate}
      />

      <CreateReminderDialog
        open={editingReminder != null}
        onClose={() => setEditingReminderId(null)}
        defaultDate={selectedDate}
        reminder={
          editingReminder
            ? {
                id: editingReminder._id,
                body: editingReminder.body,
                listId: editingReminder.listId ?? undefined,
                triggerId: editingReminder.triggerId ?? undefined,
              }
            : null
        }
        trigger={
          editingTrigger
            ? {
                id: editingTrigger._id,
                at: editingTrigger.at,
                every: editingTrigger.every,
              }
            : null
        }
      />
    </Box>
  );
}
