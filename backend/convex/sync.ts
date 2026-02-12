import { mutation, query } from "./_generated/server";
import { getAuthUserId } from "@convex-dev/auth/server";
import { v } from "convex/values";

export const pushBlob = mutation({
  args: {
    deviceId: v.string(),
    blobType: v.string(),
    blobId: v.string(),
    ciphertext: v.string(),
    iv: v.string(),
  },
  handler: async (ctx, args) => {
    const userId = await getAuthUserId(ctx);
    if (!userId) throw new Error("Not authenticated");

    // Upsert: check if blob already exists for this user
    const existing = await ctx.db
      .query("syncBlobs")
      .withIndex("by_user_blob", (q) =>
        q.eq("userId", userId).eq("blobId", args.blobId)
      )
      .first();

    if (existing) {
      await ctx.db.patch(existing._id, {
        deviceId: args.deviceId,
        blobType: args.blobType,
        ciphertext: args.ciphertext,
        iv: args.iv,
        updatedAt: Date.now(),
      });
    } else {
      await ctx.db.insert("syncBlobs", {
        userId,
        deviceId: args.deviceId,
        blobType: args.blobType,
        blobId: args.blobId,
        ciphertext: args.ciphertext,
        iv: args.iv,
        updatedAt: Date.now(),
      });
    }
  },
});

export const pullBlobs = query({
  args: {
    deviceId: v.string(),
  },
  handler: async (ctx, args) => {
    const userId = await getAuthUserId(ctx);
    if (!userId) throw new Error("Not authenticated");

    return await ctx.db
      .query("syncBlobs")
      .withIndex("by_user", (q) => q.eq("userId", userId))
      .collect();
  },
});

export const deleteBlob = mutation({
  args: {
    blobId: v.string(),
  },
  handler: async (ctx, args) => {
    const userId = await getAuthUserId(ctx);
    if (!userId) throw new Error("Not authenticated");

    const blob = await ctx.db
      .query("syncBlobs")
      .withIndex("by_user_blob", (q) =>
        q.eq("userId", userId).eq("blobId", args.blobId)
      )
      .first();

    if (blob) {
      await ctx.db.delete(blob._id);
    }
  },
});
