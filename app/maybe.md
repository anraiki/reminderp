# Reminder App — Product & Architecture Spec

## Overview

A Flutter-based reminder app that goes beyond personal productivity into community-driven, subscribable reminder lists. The core differentiator is a **reminder marketplace** where users can browse, subscribe to, and publish reminder lists — turning reminders into a social/broadcast layer.

---

## Tech Stack

- **Frontend:** Flutter (cross-platform iOS/Android)
- **Backend:** Convex (real-time database, serverless functions, auth)
- **Auth:** Convex Auth (already set up)
- **Payments:** RevenueCat (already set up — handles in-app subscriptions and purchases)
- **Notifications:** Firebase Cloud Messaging (FCM) — leveraging FCM Topics for community list subscriptions
- **State Management:** Riverpod (migrating away from GetX)

---

## Core Data Models

### User

```dart
class AppUser {
  final String id;               // Convex user ID
  final String displayName;
  final String? email;
  final String? avatarUrl;
  final SubscriptionTier tier;   // free, pro, family
  final DateTime createdAt;
  final DateTime updatedAt;
}

enum SubscriptionTier { free, pro, family }
```

### Reminder

```dart
class Reminder {
  final String id;
  final String userId;           // owner
  final String listId;           // belongs to a ReminderList
  final String body;             // the reminder text
  final DateTime? scheduledDate;
  final TimeOfDay? scheduledTime;
  final RecurrenceRule? recurrence;
  final Priority priority;
  final bool isCompleted;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
}

enum Priority { none, low, medium, high }
```

### Recurrence Rule

```dart
class RecurrenceRule {
  final RecurrenceFrequency frequency; // daily, weekly, monthly, yearly
  final int interval;                  // every N [frequency]
  final List<int>? daysOfWeek;         // 1=Mon..7=Sun (for weekly)
  final int? dayOfMonth;               // for monthly
  final DateTime? endDate;             // optional end
  final int? occurrenceCount;          // or end after N times
}

enum RecurrenceFrequency { daily, weekly, monthly, yearly }
```

### Reminder List

```dart
class ReminderList {
  final String id;
  final String ownerId;
  final String name;
  final String? description;
  final String? imageUrl;
  final ListVisibility visibility;
  final ListType type;
  final String? shareCode;         // short code / deep link for sharing
  final bool isLocked;             // requires biometric to view (private lists)
  final int subscriberCount;       // for topic lists
  final DateTime createdAt;
  final DateTime updatedAt;
}

enum ListVisibility {
  private,    // only owner sees it
  shared,     // invited collaborators
  unlisted,   // accessible via link only
  public,     // discoverable in community feed
}

enum ListType {
  personal,   // standard personal list
  shared,     // collaborative (assigned reminders)
  topic,      // one-to-many broadcast (publisher → subscribers)
  curated,    // app-maintained (holidays, deadlines, etc.)
}
```

### List Membership / Subscription

```dart
class ListMembership {
  final String id;
  final String userId;
  final String listId;
  final MemberRole role;
  final bool notificationsEnabled;
  final DateTime subscribedAt;
}

enum MemberRole {
  owner,        // created the list, full control
  editor,       // can add/edit reminders (shared lists)
  viewer,       // can see but not edit (shared lists)
  subscriber,   // receives notifications (topic lists)
}
```

### Community / Topic List Metadata

```dart
class TopicListMeta {
  final String listId;
  final String category;          // "holidays", "sports", "fitness", "local", etc.
  final List<String> tags;
  final bool isVerified;          // verified publisher badge
  final bool isFeatured;          // promoted/featured in discovery
  final int subscriberCount;
  final double rating;            // community rating
}
```

---

## Convex Schema (Reference)

Translate the above models into Convex schema tables:

```typescript
// schema.ts
import { defineSchema, defineTable } from "convex/server";
import { v } from "convex/values";

export default defineSchema({
  users: defineTable({
    displayName: v.string(),
    email: v.optional(v.string()),
    avatarUrl: v.optional(v.string()),
    tier: v.union(v.literal("free"), v.literal("pro"), v.literal("family")),
    createdAt: v.number(),
    updatedAt: v.number(),
  }),

  reminderLists: defineTable({
    ownerId: v.id("users"),
    name: v.string(),
    description: v.optional(v.string()),
    imageUrl: v.optional(v.string()),
    visibility: v.union(
      v.literal("private"),
      v.literal("shared"),
      v.literal("unlisted"),
      v.literal("public")
    ),
    type: v.union(
      v.literal("personal"),
      v.literal("shared"),
      v.literal("topic"),
      v.literal("curated")
    ),
    shareCode: v.optional(v.string()),
    isLocked: v.boolean(),
    subscriberCount: v.number(),
    createdAt: v.number(),
    updatedAt: v.number(),
  })
    .index("by_owner", ["ownerId"])
    .index("by_visibility", ["visibility"])
    .index("by_type_visibility", ["type", "visibility"])
    .index("by_share_code", ["shareCode"]),

  reminders: defineTable({
    userId: v.id("users"),
    listId: v.id("reminderLists"),
    body: v.string(),
    scheduledDate: v.optional(v.number()),
    scheduledTime: v.optional(v.string()),  // "HH:mm" format
    recurrence: v.optional(v.object({
      frequency: v.union(
        v.literal("daily"),
        v.literal("weekly"),
        v.literal("monthly"),
        v.literal("yearly")
      ),
      interval: v.number(),
      daysOfWeek: v.optional(v.array(v.number())),
      dayOfMonth: v.optional(v.number()),
      endDate: v.optional(v.number()),
      occurrenceCount: v.optional(v.number()),
    })),
    priority: v.union(
      v.literal("none"),
      v.literal("low"),
      v.literal("medium"),
      v.literal("high")
    ),
    isCompleted: v.boolean(),
    completedAt: v.optional(v.number()),
    createdAt: v.number(),
    updatedAt: v.number(),
  })
    .index("by_list", ["listId"])
    .index("by_user", ["userId"])
    .index("by_scheduled", ["scheduledDate"])
    .index("by_user_completed", ["userId", "isCompleted"]),

  listMemberships: defineTable({
    userId: v.id("users"),
    listId: v.id("reminderLists"),
    role: v.union(
      v.literal("owner"),
      v.literal("editor"),
      v.literal("viewer"),
      v.literal("subscriber")
    ),
    notificationsEnabled: v.boolean(),
    subscribedAt: v.number(),
  })
    .index("by_user", ["userId"])
    .index("by_list", ["listId"])
    .index("by_user_list", ["userId", "listId"]),

  topicListMeta: defineTable({
    listId: v.id("reminderLists"),
    category: v.string(),
    tags: v.array(v.string()),
    isVerified: v.boolean(),
    isFeatured: v.boolean(),
    subscriberCount: v.number(),
    rating: v.number(),
  })
    .index("by_list", ["listId"])
    .index("by_category", ["category"])
    .index("by_featured", ["isFeatured"]),
});
```

---

## Feature Tiers (RevenueCat Integration)

### Free Tier
- Autocomplete bar input (structured, no NLP)
- Up to 3 personal lists
- Basic reminders with single notification
- Subscribe to unlimited community/topic lists
- Browse community discovery feed

### Pro Tier ($3–5/month)
- AI natural language input (LLM-powered parsing)
- Unlimited personal lists
- Persistent nagging (re-remind every N minutes until acted on)
- Location-based reminders (geofencing triggers)
- Custom tags, smart filters, and views
- Calendar sync (Google Calendar, Apple Calendar)
- Locked/hidden private lists (biometric)
- Publish up to 5 topic lists (unlimited subscribers)
- Publisher analytics (subscriber count, engagement)

### Family / Team Tier ($6–8/month)
- Everything in Pro
- Shared collaborative lists with role-based permissions
- Reminder assignment (assign to specific family/team members)
- Publish unlimited topic lists
- Verified publisher badge (for orgs)
- Multiple publisher seats

### RevenueCat Entitlements Mapping
```
entitlement: "pro"        → Pro features
entitlement: "family"     → Family/Team features
product: "pro_monthly"    → $4.99/mo
product: "pro_yearly"     → $39.99/yr
product: "family_monthly" → $7.99/mo
product: "family_yearly"  → $59.99/yr
```

---

## Input System — Autocomplete Bar + Chips

### Interaction Flow

1. User taps input field → autocomplete bar appears above keyboard
2. User types reminder text in body field (e.g., "Pick up groceries")
3. Autocomplete bar shows contextual suggestions based on **next needed metadata**
4. User taps a suggestion → chip is added to the chip row
5. Bar advances to next metadata category
6. Repeat until user submits

### Layout (top to bottom)
```
┌─────────────────────────────────┐
│  [Autocomplete Bar]             │  ← contextual suggestions
│  tomorrow | next week | Monday  │
├─────────────────────────────────┤
│  [Chip Row]                     │  ← selected metadata as chips
│  📅 Tomorrow  🔁 Every week     │
├─────────────────────────────────┤
│  [Text Input]                   │  ← reminder body text
│  Pick up groceries              │
└─────────────────────────────────┘
│  [Keyboard]                     │
```

### Autocomplete Categories (in priority order)

The bar determines which category to show based on which `ReminderDraft` fields are still null:

1. **Date** → "Today", "Tomorrow", "Next Monday", "Next week", "Pick a date..."
2. **Recurrence** → "Every day", "Every week", "Every month", "Every year", "Custom..."
3. **Time** → "Morning (9am)", "Afternoon (1pm)", "Evening (6pm)", "Pick a time..."
4. **Priority** → "Low", "Medium", "High" (optional, skippable)
5. **List** → show user's lists to assign to (default = inbox)

### Reminder Draft State (Riverpod)

```dart
@riverpod
class ReminderDraftNotifier extends _$ReminderDraftNotifier {
  @override
  ReminderDraft build() => ReminderDraft.empty();

  void setDate(DateTime date) =>
      state = state.copyWith(scheduledDate: date);

  void setTime(TimeOfDay time) =>
      state = state.copyWith(scheduledTime: time);

  void setRecurrence(RecurrenceRule rule) =>
      state = state.copyWith(recurrence: rule);

  void setPriority(Priority priority) =>
      state = state.copyWith(priority: priority);

  void setList(String listId) =>
      state = state.copyWith(listId: listId);

  void setBody(String body) =>
      state = state.copyWith(body: body);

  void removeDate() =>
      state = state.copyWith(scheduledDate: null);

  void removeRecurrence() =>
      state = state.copyWith(recurrence: null);

  void removeTime() =>
      state = state.copyWith(scheduledTime: null);

  void reset() => state = ReminderDraft.empty();

  /// Determines which autocomplete category to show next
  AutocompleteCategory get nextCategory {
    if (state.scheduledDate == null) return AutocompleteCategory.date;
    if (state.recurrence == null) return AutocompleteCategory.recurrence;
    if (state.scheduledTime == null) return AutocompleteCategory.time;
    if (state.priority == Priority.none) return AutocompleteCategory.priority;
    return AutocompleteCategory.list;
  }
}

class ReminderDraft {
  final String body;
  final DateTime? scheduledDate;
  final TimeOfDay? scheduledTime;
  final RecurrenceRule? recurrence;
  final Priority priority;
  final String? listId;

  const ReminderDraft({
    this.body = '',
    this.scheduledDate,
    this.scheduledTime,
    this.recurrence,
    this.priority = Priority.none,
    this.listId,
  });

  factory ReminderDraft.empty() => const ReminderDraft();

  ReminderDraft copyWith({...});
}

enum AutocompleteCategory { date, recurrence, time, priority, list }
```

### Chip Behavior
- Tapping a chip → reopens autocomplete bar filtered to that category for editing
- Swiping or tapping X on chip → removes that metadata, bar resurfaces that category
- Chips are rendered using `InputChip` or custom `Chip` widget in a `Wrap`

---

## Community / Topic Lists — Discovery Feed

### Browse Experience

New users and returning users see a discovery feed:

```
┌─────────────────────────────────┐
│  🔍 Search community lists      │
├─────────────────────────────────┤
│  📌 Popular This Month          │
│  ☐ Valentine's Day — Feb 14     │
│  ☐ Presidents' Day — Feb 17     │
│  ☐ Daylight Savings — Mar 9     │
├─────────────────────────────────┤
│  🏋️ Fitness & Health            │
│  ☐ 30-Day Abs Challenge         │
│  ☐ Couch to 5K Schedule         │
├─────────────────────────────────┤
│  📚 Education                   │
│  ☐ SAT Prep Deadlines 2026      │
│  ☐ AP Exam Schedule             │
├─────────────────────────────────┤
│  📍 Local (Santa Ana, CA)       │
│  ☐ City Council Meetings        │
│  ☐ Farmers Market Schedule      │
└─────────────────────────────────┘
```

### Subscribe Flow
1. User taps checkbox next to a community reminder/topic list
2. App subscribes user via `listMemberships` table (role: subscriber)
3. FCM topic subscription is created for push notifications
4. Reminders from that list appear in user's feed with a badge showing source
5. User can mute notifications per list without unsubscribing

### Publishing Flow (Pro+)
1. User creates a new list → selects type "Topic" and visibility "Public" or "Unlisted"
2. Adds reminders to the list as usual
3. Gets a share code / deep link to distribute
4. If visibility is "Public," list appears in community discovery feed
5. Publisher dashboard shows subscriber count, engagement metrics

### Categories for Discovery
- Holidays & Events
- Fitness & Health
- Education & Deadlines
- Sports Schedules
- Local / Community
- Business & Finance (tax deadlines, earnings dates)
- Entertainment (show premieres, game releases)
- Custom / Other

---

## Notification System

### Notification Types

| Type | Trigger | Tier |
|------|---------|------|
| Single reminder | Fires once at scheduled time | Free |
| Persistent nag | Repeats every N min until dismissed/completed | Pro |
| Location-based | Fires when entering/leaving geofence | Pro |
| Topic broadcast | Publisher sends to all subscribers via FCM topic | Free (receive) / Pro (publish) |

### FCM Topic Naming Convention
```
reminder_list_{listId}
```
- Subscribe user to topic on list subscription
- Unsubscribe on list unsubscribe or notification mute
- Publisher triggers notification via Convex function → FCM topic message

### Persistent Nagging (Pro)
```dart
class NagConfig {
  final Duration interval;    // every 5, 10, 15 min
  final int maxNags;          // stop after N nags (default: 10)
  final bool requireAction;   // only stop on complete/snooze, not dismiss
}
```

---

## Screen Map

```
App
├── Auth (Convex Auth)
│   ├── Login
│   └── Register
├── Home (TabBar)
│   ├── My Reminders (default tab)
│   │   ├── Inbox (unsorted reminders)
│   │   ├── Personal Lists
│   │   ├── Shared Lists
│   │   └── Subscribed Topic Lists
│   ├── Discovery Feed
│   │   ├── Featured / Trending
│   │   ├── Categories
│   │   ├── Search
│   │   └── Topic List Detail → Subscribe
│   └── Settings
│       ├── Account & Profile
│       ├── Subscription Management (RevenueCat)
│       ├── Notification Preferences
│       ├── Calendar Sync (Pro)
│       └── Publisher Dashboard (Pro)
├── Create/Edit Reminder (bottom sheet or full screen)
│   ├── Text Input
│   ├── Chip Row
│   └── Autocomplete Bar
├── List Management
│   ├── Create List
│   ├── Edit List (name, visibility, type)
│   ├── Share List (invite / generate link)
│   └── List Settings (notifications, lock)
└── Paywall (RevenueCat paywall UI)
    ├── Pro Upsell
    └── Family Upsell
```

---

## Key Convex Functions

```typescript
// Reminders
mutation: createReminder({ body, listId, scheduledDate, ... })
mutation: updateReminder({ id, ... })
mutation: completeReminder({ id })
mutation: deleteReminder({ id })
query:    getRemindersForList({ listId })
query:    getUpcomingReminders({ userId, limit })
query:    getOverdueReminders({ userId })

// Lists
mutation: createList({ name, visibility, type, ... })
mutation: updateList({ id, ... })
mutation: deleteList({ id })
query:    getMyLists({ userId })
query:    getSharedLists({ userId })
query:    getSubscribedLists({ userId })

// Community / Discovery
query:    getFeaturedTopicLists({ limit })
query:    getTopicListsByCategory({ category, limit })
query:    searchTopicLists({ query })
mutation: subscribeToList({ userId, listId })
mutation: unsubscribeFromList({ userId, listId })

// Publishing
mutation: publishReminder({ listId, body, scheduledDate, ... })
action:  broadcastNotification({ listId, reminderId }) // triggers FCM topic message

// Analytics (Pro)
query:    getPublisherAnalytics({ userId })
query:    getListEngagement({ listId })
```

---

## AI Natural Language Input (Pro Feature)

### Architecture
- **Local first:** Dart-based date parser handles common patterns ("tomorrow", "next Monday", "in 2 hours")
- **LLM fallback:** If local parser can't extract a date/time, send to Claude API for structured extraction
- **Response format:**

```json
{
  "body": "Call the plumber about the kitchen leak",
  "scheduledDate": "2026-02-17",
  "scheduledTime": "09:00",
  "recurrence": null,
  "priority": "medium"
}
```

- **UX:** After parsing, show result as chips for user confirmation/editing
- **Cost management:** Cache common patterns locally, only hit API for complex inputs
- **Gate:** Check RevenueCat entitlement "pro" before allowing NLP input

---

## Implementation Priority

### Phase 1 — MVP (Personal Reminders)
1. Auth flow (Convex — already done)
2. Reminder CRUD with Convex
3. Autocomplete bar + chip input system
4. Basic notification scheduling (single fire)
5. Personal lists (private only)
6. RevenueCat paywall integration (already set up)

### Phase 2 — Community Layer
7. Topic list data model + CRUD
8. Discovery feed UI
9. Subscribe/unsubscribe flow
10. FCM topic-based notifications for broadcasts
11. Share codes / deep links for lists

### Phase 3 — Pro Features
12. AI natural language input (LLM integration)
13. Persistent nagging notifications
14. Location-based reminders (geofencing)
15. Calendar sync
16. Publisher dashboard + analytics
17. Locked/hidden private lists

### Phase 4 — Growth
18. Curated official lists (holidays, deadlines)
19. Featured/promoted placement for publishers
20. Verified publisher badges
21. Family/Team tier with collaborative features
22. Widgets (iOS/Android home screen)