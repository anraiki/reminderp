import { useQuery } from "convex/react";
import { api } from "convex/_generated/api";
import { DayPicker } from "react-day-picker";
import { isSameDay } from "date-fns";
import { Box } from "@chakra-ui/react";
import { useMemo } from "react";

interface CalendarViewProps {
  selectedDate: Date;
  onSelectDate: (date: Date) => void;
}

export function CalendarView({ selectedDate, onSelectDate }: CalendarViewProps) {
  const reminders = useQuery(api.reminders.listByUser) ?? [];
  const triggers = useQuery(api.triggers.listByUser) ?? [];

  const datesWithReminders = useMemo(() => {
    const triggerMap = new Map(triggers.map((t) => [t._id, t]));
    const dates: Date[] = [];

    for (const reminder of reminders) {
      if (reminder.triggerId) {
        const trigger = triggerMap.get(reminder.triggerId);
        if (trigger) {
          dates.push(new Date(trigger.at));
        }
      }
    }

    return dates;
  }, [reminders, triggers]);

  const modifiers = {
    hasReminder: (date: Date) =>
      datesWithReminders.some((d) => isSameDay(d, date)),
  };

  const modifiersStyles = {
    hasReminder: {
      position: "relative" as const,
    },
  };

  return (
    <Box
      bg="#2D3748"
      borderRadius="lg"
      p="4"
      css={{
        ".rdp": {
          "--rdp-accent-color": "#319795",
          "--rdp-background-color": "#319795",
          "--rdp-accent-background-color": "rgba(49, 151, 149, 0.2)",
          color: "#E2E8F0",
        },
        ".rdp-day_button": {
          color: "#E2E8F0",
        },
        ".rdp-chevron": {
          fill: "#319795",
        },
        ".rdp-selected .rdp-day_button": {
          backgroundColor: "#319795",
          color: "white",
        },
        ".rdp-today .rdp-day_button": {
          fontWeight: "bold",
          color: "#319795",
        },
        ".rdp-selected.rdp-today .rdp-day_button": {
          color: "white",
        },
        "[data-has-reminder]::after": {
          content: '""',
          position: "absolute",
          bottom: "2px",
          left: "50%",
          transform: "translateX(-50%)",
          width: "4px",
          height: "4px",
          borderRadius: "50%",
          backgroundColor: "#48BB78",
        },
      }}
    >
      <DayPicker
        mode="single"
        selected={selectedDate}
        onSelect={(date) => date && onSelectDate(date)}
        modifiers={modifiers}
        modifiersStyles={modifiersStyles}
      />
    </Box>
  );
}
