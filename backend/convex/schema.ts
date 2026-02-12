import { defineSchema, defineTable } from "convex/server";
import { authTables } from "@convex-dev/auth/server";
import { v } from "convex/values";

export default defineSchema({
  ...authTables,

  syncBlobs: defineTable({
    userId: v.string(),
    deviceId: v.string(),
    blobType: v.string(),
    blobId: v.string(),
    ciphertext: v.string(),
    iv: v.string(),
    updatedAt: v.number(),
  })
    .index("by_user", ["userId"])
    .index("by_user_device", ["userId", "deviceId"])
    .index("by_user_blob", ["userId", "blobId"]),

  profiles: defineTable({
    userId: v.id("users"),
    syncEnabled: v.boolean(),
    consentGranted: v.boolean(),
    consentDate: v.optional(v.number()),
  }).index("by_user_id", ["userId"]),

  patterns: defineTable({
    name: v.string(),
    creatorId: v.string(),
    visibility: v.string(), // 'public', 'private', 'shared'
    forkedFrom: v.optional(v.id("patterns")),
    moments: v.array(
      v.object({
        offset: v.number(),
        voices: v.array(
          v.object({
            type: v.string(),
            intensity: v.optional(v.number()),
            duration: v.optional(v.number()),
            repeat: v.optional(v.number()),
            gap: v.optional(v.number()),
            pattern: v.optional(v.string()),
            escalationStep: v.optional(v.number()),
            escalationEvery: v.optional(v.number()),
            escalationMax: v.optional(v.number()),
          })
        ),
      })
    ),
  })
    .index("by_creator", ["creatorId"])
    .index("by_visibility", ["visibility"]),

  patternShares: defineTable({
    patternId: v.id("patterns"),
    sharedWith: v.string(),
  })
    .index("by_pattern", ["patternId"])
    .index("by_shared_with", ["sharedWith"]),

  reminderLists: defineTable({
    userId: v.id("users"),
    name: v.string(),
    iconName: v.string(),
    createdAt: v.number(),
    updatedAt: v.number(),
  }).index("by_user", ["userId"]),

  reminders: defineTable({
    userId: v.id("users"),
    body: v.optional(v.string()),
    createdAt: v.number(),
    updatedAt: v.number(),
    triggerId: v.optional(v.id("triggers")),
    listId: v.optional(v.id("reminderLists")),
    patternId: v.optional(v.id("patterns")),
    overrides: v.array(
      v.object({
        momentOffset: v.number(),
        action: v.string(),
        moment: v.optional(
          v.object({
            offset: v.number(),
            voices: v.array(
              v.object({
                type: v.string(),
                intensity: v.optional(v.number()),
                duration: v.optional(v.number()),
                repeat: v.optional(v.number()),
                gap: v.optional(v.number()),
                pattern: v.optional(v.string()),
                escalationStep: v.optional(v.number()),
                escalationEvery: v.optional(v.number()),
                escalationMax: v.optional(v.number()),
              })
            ),
          })
        ),
      })
    ),
  })
    .index("by_user", ["userId"])
    .index("by_user_list", ["userId", "listId"]),

  triggers: defineTable({
    userId: v.id("users"),
    at: v.number(),
    every: v.optional(v.string()),
    times: v.optional(v.number()),
    patternId: v.optional(v.id("patterns")),
    updatedAt: v.number(),
  }).index("by_user", ["userId"]),
});
