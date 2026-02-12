import { mutation, query } from "./_generated/server";
import { getAuthUserId } from "@convex-dev/auth/server";
import { v } from "convex/values";

const overrideValidator = v.object({
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
});

export const listByUser = query({
  args: {},
  handler: async (ctx) => {
    const userId = await getAuthUserId(ctx);
    if (!userId) throw new Error("Not authenticated");

    return await ctx.db
      .query("reminders")
      .withIndex("by_user", (q) => q.eq("userId", userId))
      .collect();
  },
});

export const create = mutation({
  args: {
    body: v.optional(v.string()),
    triggerId: v.optional(v.id("triggers")),
    listId: v.optional(v.id("reminderLists")),
    patternId: v.optional(v.id("patterns")),
    overrides: v.array(overrideValidator),
  },
  handler: async (ctx, args) => {
    const userId = await getAuthUserId(ctx);
    if (!userId) throw new Error("Not authenticated");

    const now = Date.now();
    return await ctx.db.insert("reminders", {
      userId,
      body: args.body,
      createdAt: now,
      updatedAt: now,
      triggerId: args.triggerId,
      listId: args.listId,
      patternId: args.patternId,
      overrides: args.overrides,
    });
  },
});

export const update = mutation({
  args: {
    id: v.id("reminders"),
    body: v.optional(v.string()),
    triggerId: v.optional(v.id("triggers")),
    listId: v.optional(v.id("reminderLists")),
    patternId: v.optional(v.id("patterns")),
    overrides: v.optional(v.array(overrideValidator)),
  },
  handler: async (ctx, args) => {
    const userId = await getAuthUserId(ctx);
    if (!userId) throw new Error("Not authenticated");

    const reminder = await ctx.db.get(args.id);
    if (!reminder || reminder.userId !== userId) {
      throw new Error("Not authorized");
    }

    const updates: Record<string, unknown> = { updatedAt: Date.now() };
    if (args.body !== undefined) updates.body = args.body;
    if (args.triggerId !== undefined) updates.triggerId = args.triggerId;
    if (args.listId !== undefined) updates.listId = args.listId;
    if (args.patternId !== undefined) updates.patternId = args.patternId;
    if (args.overrides !== undefined) updates.overrides = args.overrides;

    await ctx.db.patch(args.id, updates);
  },
});

export const remove = mutation({
  args: { id: v.id("reminders") },
  handler: async (ctx, args) => {
    const userId = await getAuthUserId(ctx);
    if (!userId) throw new Error("Not authenticated");

    const reminder = await ctx.db.get(args.id);
    if (!reminder || reminder.userId !== userId) {
      throw new Error("Not authorized");
    }

    await ctx.db.delete(args.id);
  },
});
