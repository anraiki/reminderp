import { mutation, query } from "./_generated/server";
import { getAuthUserId } from "@convex-dev/auth/server";

export const getOrCreate = mutation({
  args: {},
  handler: async (ctx) => {
    const userId = await getAuthUserId(ctx);
    if (!userId) throw new Error("Not authenticated");

    const existing = await ctx.db
      .query("profiles")
      .withIndex("by_user_id", (q) => q.eq("userId", userId))
      .first();

    if (existing) return existing;

    const id = await ctx.db.insert("profiles", {
      userId,
      syncEnabled: false,
      consentGranted: false,
    });

    return await ctx.db.get(id);
  },
});

export const getMe = query({
  args: {},
  handler: async (ctx) => {
    const userId = await getAuthUserId(ctx);
    if (!userId) return null;

    return await ctx.db
      .query("profiles")
      .withIndex("by_user_id", (q) => q.eq("userId", userId))
      .first();
  },
});

export const grantConsent = mutation({
  args: {},
  handler: async (ctx) => {
    const userId = await getAuthUserId(ctx);
    if (!userId) throw new Error("Not authenticated");

    const profile = await ctx.db
      .query("profiles")
      .withIndex("by_user_id", (q) => q.eq("userId", userId))
      .first();

    if (!profile) throw new Error("Profile not found");

    await ctx.db.patch(profile._id, {
      consentGranted: true,
      consentDate: Date.now(),
    });
  },
});

export const revokeConsent = mutation({
  args: {},
  handler: async (ctx) => {
    const userId = await getAuthUserId(ctx);
    if (!userId) throw new Error("Not authenticated");

    const profile = await ctx.db
      .query("profiles")
      .withIndex("by_user_id", (q) => q.eq("userId", userId))
      .first();

    if (!profile) throw new Error("Profile not found");

    await ctx.db.patch(profile._id, {
      consentGranted: false,
      syncEnabled: false,
    });

    // Delete all synced blobs for this user
    const blobs = await ctx.db
      .query("syncBlobs")
      .withIndex("by_user", (q) => q.eq("userId", userId))
      .collect();

    for (const blob of blobs) {
      await ctx.db.delete(blob._id);
    }
  },
});

export const enableSync = mutation({
  args: {},
  handler: async (ctx) => {
    const userId = await getAuthUserId(ctx);
    if (!userId) throw new Error("Not authenticated");

    const profile = await ctx.db
      .query("profiles")
      .withIndex("by_user_id", (q) => q.eq("userId", userId))
      .first();

    if (!profile) throw new Error("Profile not found");
    if (!profile.consentGranted) throw new Error("Consent not granted");

    await ctx.db.patch(profile._id, { syncEnabled: true });
  },
});

export const disableSync = mutation({
  args: {},
  handler: async (ctx) => {
    const userId = await getAuthUserId(ctx);
    if (!userId) throw new Error("Not authenticated");

    const profile = await ctx.db
      .query("profiles")
      .withIndex("by_user_id", (q) => q.eq("userId", userId))
      .first();

    if (!profile) throw new Error("Profile not found");

    await ctx.db.patch(profile._id, { syncEnabled: false });
  },
});
