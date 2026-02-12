import { mutation, query } from "./_generated/server";
import { getAuthUserId } from "@convex-dev/auth/server";
import { v } from "convex/values";

export const listByUser = query({
  args: {},
  handler: async (ctx) => {
    const userId = await getAuthUserId(ctx);
    if (!userId) throw new Error("Not authenticated");

    return await ctx.db
      .query("triggers")
      .withIndex("by_user", (q) => q.eq("userId", userId))
      .collect();
  },
});

export const create = mutation({
  args: {
    at: v.number(),
    every: v.optional(v.string()),
    times: v.optional(v.number()),
    patternId: v.optional(v.id("patterns")),
  },
  handler: async (ctx, args) => {
    const userId = await getAuthUserId(ctx);
    if (!userId) throw new Error("Not authenticated");

    return await ctx.db.insert("triggers", {
      userId,
      at: args.at,
      every: args.every,
      times: args.times,
      patternId: args.patternId,
      updatedAt: Date.now(),
    });
  },
});

export const update = mutation({
  args: {
    id: v.id("triggers"),
    at: v.optional(v.number()),
    every: v.optional(v.string()),
    times: v.optional(v.number()),
    patternId: v.optional(v.id("patterns")),
  },
  handler: async (ctx, args) => {
    const userId = await getAuthUserId(ctx);
    if (!userId) throw new Error("Not authenticated");

    const trigger = await ctx.db.get(args.id);
    if (!trigger || trigger.userId !== userId) {
      throw new Error("Not authorized");
    }

    const updates: Record<string, unknown> = { updatedAt: Date.now() };
    if (args.at !== undefined) updates.at = args.at;
    if (args.every !== undefined) updates.every = args.every;
    if (args.times !== undefined) updates.times = args.times;
    if (args.patternId !== undefined) updates.patternId = args.patternId;

    await ctx.db.patch(args.id, updates);
  },
});

export const remove = mutation({
  args: { id: v.id("triggers") },
  handler: async (ctx, args) => {
    const userId = await getAuthUserId(ctx);
    if (!userId) throw new Error("Not authenticated");

    const trigger = await ctx.db.get(args.id);
    if (!trigger || trigger.userId !== userId) {
      throw new Error("Not authorized");
    }

    await ctx.db.delete(args.id);
  },
});
