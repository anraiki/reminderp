import { mutation, query } from "./_generated/server";
import { getAuthUserId } from "@convex-dev/auth/server";
import { v } from "convex/values";

export const listByUser = query({
  args: {},
  handler: async (ctx) => {
    const userId = await getAuthUserId(ctx);
    if (!userId) throw new Error("Not authenticated");

    return await ctx.db
      .query("reminderLists")
      .withIndex("by_user", (q) => q.eq("userId", userId))
      .collect();
  },
});

export const create = mutation({
  args: {
    name: v.string(),
    iconName: v.string(),
  },
  handler: async (ctx, args) => {
    const userId = await getAuthUserId(ctx);
    if (!userId) throw new Error("Not authenticated");

    const now = Date.now();
    return await ctx.db.insert("reminderLists", {
      userId,
      name: args.name,
      iconName: args.iconName,
      createdAt: now,
      updatedAt: now,
    });
  },
});

export const update = mutation({
  args: {
    id: v.id("reminderLists"),
    name: v.optional(v.string()),
    iconName: v.optional(v.string()),
  },
  handler: async (ctx, args) => {
    const userId = await getAuthUserId(ctx);
    if (!userId) throw new Error("Not authenticated");

    const list = await ctx.db.get(args.id);
    if (!list || list.userId !== userId) {
      throw new Error("Not authorized");
    }

    const updates: Record<string, unknown> = { updatedAt: Date.now() };
    if (args.name !== undefined) updates.name = args.name;
    if (args.iconName !== undefined) updates.iconName = args.iconName;

    await ctx.db.patch(args.id, updates);
  },
});

export const remove = mutation({
  args: { id: v.id("reminderLists") },
  handler: async (ctx, args) => {
    const userId = await getAuthUserId(ctx);
    if (!userId) throw new Error("Not authenticated");

    const list = await ctx.db.get(args.id);
    if (!list || list.userId !== userId) {
      throw new Error("Not authorized");
    }

    // Unassign reminders in this list
    const reminders = await ctx.db
      .query("reminders")
      .withIndex("by_user_list", (q) =>
        q.eq("userId", userId).eq("listId", args.id)
      )
      .collect();

    for (const reminder of reminders) {
      await ctx.db.patch(reminder._id, { listId: undefined, updatedAt: Date.now() });
    }

    await ctx.db.delete(args.id);
  },
});
