import { mutation, query } from "./_generated/server";
import { getAuthUserId } from "@convex-dev/auth/server";
import { v } from "convex/values";

const momentValidator = v.object({
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
});

export const create = mutation({
  args: {
    name: v.string(),
    visibility: v.string(),
    moments: v.array(momentValidator),
    forkedFrom: v.optional(v.id("patterns")),
  },
  handler: async (ctx, args) => {
    const userId = await getAuthUserId(ctx);
    if (!userId) throw new Error("Not authenticated");

    return await ctx.db.insert("patterns", {
      name: args.name,
      creatorId: userId,
      visibility: args.visibility,
      moments: args.moments,
      forkedFrom: args.forkedFrom,
    });
  },
});

export const listPublic = query({
  args: {},
  handler: async (ctx) => {
    return await ctx.db
      .query("patterns")
      .withIndex("by_visibility", (q) => q.eq("visibility", "public"))
      .collect();
  },
});

export const listMine = query({
  args: {},
  handler: async (ctx) => {
    const userId = await getAuthUserId(ctx);
    if (!userId) throw new Error("Not authenticated");

    return await ctx.db
      .query("patterns")
      .withIndex("by_creator", (q) => q.eq("creatorId", userId))
      .collect();
  },
});

export const get = query({
  args: { id: v.id("patterns") },
  handler: async (ctx, args) => {
    return await ctx.db.get(args.id);
  },
});

export const update = mutation({
  args: {
    id: v.id("patterns"),
    name: v.optional(v.string()),
    visibility: v.optional(v.string()),
    moments: v.optional(v.array(momentValidator)),
  },
  handler: async (ctx, args) => {
    const userId = await getAuthUserId(ctx);
    if (!userId) throw new Error("Not authenticated");

    const pattern = await ctx.db.get(args.id);
    if (!pattern || pattern.creatorId !== userId) {
      throw new Error("Not authorized");
    }

    const updates: Record<string, unknown> = {};
    if (args.name !== undefined) updates.name = args.name;
    if (args.visibility !== undefined) updates.visibility = args.visibility;
    if (args.moments !== undefined) updates.moments = args.moments;

    await ctx.db.patch(args.id, updates);
  },
});

export const remove = mutation({
  args: { id: v.id("patterns") },
  handler: async (ctx, args) => {
    const userId = await getAuthUserId(ctx);
    if (!userId) throw new Error("Not authenticated");

    const pattern = await ctx.db.get(args.id);
    if (!pattern || pattern.creatorId !== userId) {
      throw new Error("Not authorized");
    }

    // Delete associated shares
    const shares = await ctx.db
      .query("patternShares")
      .withIndex("by_pattern", (q) => q.eq("patternId", args.id))
      .collect();

    for (const share of shares) {
      await ctx.db.delete(share._id);
    }

    await ctx.db.delete(args.id);
  },
});

export const fork = mutation({
  args: { id: v.id("patterns") },
  handler: async (ctx, args) => {
    const userId = await getAuthUserId(ctx);
    if (!userId) throw new Error("Not authenticated");

    const original = await ctx.db.get(args.id);
    if (!original) throw new Error("Pattern not found");

    return await ctx.db.insert("patterns", {
      name: `${original.name} (fork)`,
      creatorId: userId,
      visibility: "private",
      moments: original.moments,
      forkedFrom: args.id,
    });
  },
});

export const share = mutation({
  args: {
    patternId: v.id("patterns"),
    sharedWith: v.string(),
  },
  handler: async (ctx, args) => {
    const userId = await getAuthUserId(ctx);
    if (!userId) throw new Error("Not authenticated");

    const pattern = await ctx.db.get(args.patternId);
    if (!pattern || pattern.creatorId !== userId) {
      throw new Error("Not authorized");
    }

    return await ctx.db.insert("patternShares", {
      patternId: args.patternId,
      sharedWith: args.sharedWith,
    });
  },
});

export const listSharedWithMe = query({
  args: {},
  handler: async (ctx) => {
    const userId = await getAuthUserId(ctx);
    if (!userId) throw new Error("Not authenticated");

    const shares = await ctx.db
      .query("patternShares")
      .withIndex("by_shared_with", (q) =>
        q.eq("sharedWith", userId)
      )
      .collect();

    const patterns = await Promise.all(
      shares.map((s) => ctx.db.get(s.patternId))
    );

    return patterns.filter((p) => p !== null);
  },
});
