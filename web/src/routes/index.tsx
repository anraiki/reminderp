import { createFileRoute } from "@tanstack/react-router";
import { useState } from "react";
import { Box, Flex, Heading } from "@chakra-ui/react";
import { CalendarView } from "../components/reminders/CalendarView";
import { ReminderList } from "../components/reminders/ReminderList";

function HomePage() {
  const [selectedDate, setSelectedDate] = useState<Date>(new Date());

  return (
    <Flex direction="column" h="full" p="6" gap="6">
      <Heading size="lg">Reminders</Heading>
      <Flex
        direction={{ base: "column", lg: "row" }}
        gap="6"
        flex="1"
        minH="0"
      >
        <Box flexShrink={0}>
          <CalendarView
            selectedDate={selectedDate}
            onSelectDate={setSelectedDate}
          />
        </Box>
        <Box flex="1" minH="0" overflowY="auto">
          <ReminderList selectedDate={selectedDate} />
        </Box>
      </Flex>
    </Flex>
  );
}

export const Route = createFileRoute("/")({
  component: HomePage,
});
