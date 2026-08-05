# Kumele Backend — Full Endpoint Catalog (generated reference)

Generated 2026-07-24 from the live backend's Swagger UI at `http://84.247.131.180/docs` (spec embedded in `swagger-ui-init.js`). Raw OpenAPI JSON: [`openapi.json`](openapi.json).

Base URL: `http://84.247.131.180/api/v1`

Total: 248 endpoints across 40 tags.

See [`../02_APIIntegrationGuide.md`](../02_APIIntegrationGuide.md) for how this compares to what the Swift app currently assumes, and [`../07_BackendContractFindings.md`](../07_BackendContractFindings.md) for the critical contract mismatches found so far (Auth).


## Admin - Ads (2)

| Method | Path | Auth | Summary |
|---|---|---|---|
| GET | `/api/v1/admin/ads/review` | auth | List ads pending review |
| POST | `/api/v1/admin/ads/{id}/review` | auth | Approve, reject, or takedown an ad |

## Admin - Blogs (2)

| Method | Path | Auth | Summary |
|---|---|---|---|
| GET | `/api/v1/admin/blogs/moderation` | auth | List blogs pending moderation |
| POST | `/api/v1/admin/blogs/{id}/moderate` | auth | Approve, reject, or takedown a blog post |

## Admin - Events (5)

| Method | Path | Auth | Summary |
|---|---|---|---|
| GET | `/api/v1/admin/events/moderation` | auth | List events pending moderation |
| POST | `/api/v1/admin/events/{id}/moderate` | auth | Approve, reject, or takedown an event |
| GET | `/api/v1/admin/events/ratings` | auth | List all event ratings (admin — filterable, paginated) |
| PATCH | `/api/v1/admin/events/ratings/{ratingId}/flag` | auth | Flag/unflag a rating (admin moderation) |
| DELETE | `/api/v1/admin/events/ratings/{ratingId}` | auth | Delete a rating (admin) |

## Admin - NFTs (4)

| Method | Path | Auth | Summary |
|---|---|---|---|
| GET | `/api/v1/admin/nfts` | auth | List all NFTs (admin view, paginated) |
| POST | `/api/v1/admin/nfts` | auth | Create a new NFT collection item |
| PUT | `/api/v1/admin/nfts/{id}` | auth | Update an NFT collection item |
| DELETE | `/api/v1/admin/nfts/{id}` | auth | Delete an NFT collection item |

## Admin - Support (6)

| Method | Path | Auth | Summary |
|---|---|---|---|
| GET | `/api/v1/admin/support/tickets` | auth | Get all support tickets (admin) |
| GET | `/api/v1/admin/support/tickets/{id}` | auth | Get support ticket details (admin) |
| PUT | `/api/v1/admin/support/tickets/{id}/status` | auth | Update ticket status |
| POST | `/api/v1/admin/support/tickets/{id}/assign` | auth | Assign ticket to support agent |
| POST | `/api/v1/admin/support/tickets/{id}/reply` | auth | Add admin reply to ticket |
| GET | `/api/v1/admin/support/statistics` | auth | Get support ticket statistics |

## Admin - Users (3)

| Method | Path | Auth | Summary |
|---|---|---|---|
| GET | `/api/v1/admin/users` | auth | List all users (admin) |
| GET | `/api/v1/admin/users/{id}` | auth | Get user details (admin) |
| POST | `/api/v1/admin/users/{id}/suspend` | auth | Suspend or unsuspend a user |

## Ads (12)

| Method | Path | Auth | Summary |
|---|---|---|---|
| POST | `/api/v1/ads/campaigns` | auth | Create a new ad campaign |
| GET | `/api/v1/ads/campaigns` | auth | List my ad campaigns |
| PUT | `/api/v1/ads/campaigns/{id}` | auth | Update an ad campaign |
| GET | `/api/v1/ads/campaigns/{id}` | auth | Get campaign details with ads |
| GET | `/api/v1/ads/dashboard/stats` | auth | Get ad campaign history and statistics |
| GET | `/api/v1/ads/fetch` | auth | Fetch ads for display (ML + fallback) |
| POST | `/api/v1/ads/track` | auth | Track ad view/click/conversion |
| GET | `/api/v1/ads/admob/context` | auth | Get AdMob context for fallback |
| POST | `/api/v1/ads` | auth | Create a new ad (triggers moderation) |
| PUT | `/api/v1/ads/{id}` | auth | Update an ad |
| GET | `/api/v1/ads/{id}` | auth | Get ad details with stats |
| DELETE | `/api/v1/ads/{id}` | auth | Delete an ad |

## App Config (2)

| Method | Path | Auth | Summary |
|---|---|---|---|
| GET | `/api/v1/app/config` | public | Get app configuration (maintenance mode, versions, feature flags) |
| GET | `/api/v1/app/health` | public | App health check (for load balancers) |

## Auth (26)

| Method | Path | Auth | Summary |
|---|---|---|---|
| POST | `/api/v1/auth/signup` | public | Register a new user |
| POST | `/api/v1/auth/login` | public | Login with email and password |
| POST | `/api/v1/auth/business/signup` | public | Register a new business user |
| POST | `/api/v1/auth/business/login` | public | Login for business users |
| POST | `/api/v1/auth/logout` | auth | Logout current session |
| POST | `/api/v1/auth/logout-all` | auth | Logout from all devices |
| POST | `/api/v1/auth/refresh` | public | Refresh access token |
| GET | `/api/v1/auth/google` | public | Initiate Google OAuth login |
| GET | `/api/v1/auth/google/callback` | public | Google OAuth callback |
| POST | `/api/v1/auth/firebase-login` | public | Firebase token login (Flutter / mobile) |
| POST | `/api/v1/auth/passkey/register/start` | auth | Start passkey registration |
| POST | `/api/v1/auth/passkey/register/finish` | auth | Complete passkey registration |
| POST | `/api/v1/auth/passkey/login/start` | public | Start passkey login |
| POST | `/api/v1/auth/passkey/login/finish` | public | Complete passkey login |
| POST | `/api/v1/auth/forgot-password` | public | Request password reset OTP (sent to email) |
| POST | `/api/v1/auth/verify-reset-otp` | public | Verify password reset OTP and get a one-time reset token |
| POST | `/api/v1/auth/reset-password` | public | Reset password using token from /auth/verify-reset-otp |
| POST | `/api/v1/auth/change-password` | auth | Change password (authenticated) |
| POST | `/api/v1/auth/send-verification-email` | auth | Send email verification OTP |
| POST | `/api/v1/auth/verify-email` | auth | Verify email with OTP code |
| POST | `/api/v1/auth/resend-verification` | auth | Resend verification email |
| POST | `/api/v1/auth/2fa/setup` | auth | Set up 2FA — returns QR code and secret |
| POST | `/api/v1/auth/2fa/enable` | auth | Enable 2FA after verifying a TOTP code |
| POST | `/api/v1/auth/2fa/disable` | auth | Disable 2FA |
| POST | `/api/v1/auth/2fa/verify` | public | Complete 2FA login with TOTP code |
| GET | `/api/v1/auth/me` | auth | Get current authenticated user |

## Blogs (8)

| Method | Path | Auth | Summary |
|---|---|---|---|
| GET | `/api/v1/blogs/feed` | public | Get blog feed (cursor-based pagination, approved + visibility filtered) |
| GET | `/api/v1/blogs/public/{slug}` | public | Get public SEO blog post by slug |
| GET | `/api/v1/blogs/sitemap` | public | Get list of public SEO blog slugs for sitemap |
| GET | `/api/v1/blogs/{id}` | public | Get blog post detail by ID (pass JWT to get is_liked) |
| GET | `/api/v1/blogs/{id}/comments` | public | Get comments for a blog post (cursor-based) |
| POST | `/api/v1/blogs/{id}/comments` | auth | Add a comment to a blog post |
| POST | `/api/v1/blogs` | auth | Create a blog post (with markdown processing pipeline) |
| POST | `/api/v1/blogs/{id}/like` | auth | Toggle like on a blog post |

## Health (3)

| Method | Path | Auth | Summary |
|---|---|---|---|
| GET | `/api/v1/health` | public | Check application health |
| GET | `/api/v1/health/live` | public | Liveness probe for Kubernetes |
| GET | `/api/v1/health/ready` | public | Readiness probe for Kubernetes |

## Localization (2)

| Method | Path | Auth | Summary |
|---|---|---|---|
| GET | `/api/v1/localization/strings` | public | Get localization strings by language |
| GET | `/api/v1/localization/languages` | public | Get available languages |

## Media (1)

| Method | Path | Auth | Summary |
|---|---|---|---|
| POST | `/api/v1/media/upload` | auth | Upload image or video |

## Metrics (1)

| Method | Path | Auth | Summary |
|---|---|---|---|
| GET | `/api/v1/metrics` | public | Get Prometheus metrics |

## NFTs (8)

| Method | Path | Auth | Summary |
|---|---|---|---|
| GET | `/api/v1/nfts/my-screen` | auth | Get personalized NFT screen (owned, claimable, marketplace, exclusive) |
| GET | `/api/v1/nfts/rewards` | auth | Get all reward NFTs (earned status per user) |
| GET | `/api/v1/nfts/mine` | auth | Get all NFTs owned by the current user |
| GET | `/api/v1/nfts/marketplace` | public | Browse NFT marketplace (filterable, paginated) |
| GET | `/api/v1/nfts/{id}` | public | Get NFT details by ID |
| POST | `/api/v1/nfts/{id}/claim` | auth | Claim a free reward NFT |
| POST | `/api/v1/nfts/{id}/purchase` | auth | Purchase an NFT |
| POST | `/api/v1/nfts/internal/auto-issue` | public | Auto-issue reward NFTs when user earns a tier (internal — X-Service-Key) |

## Notifications (6)

| Method | Path | Auth | Summary |
|---|---|---|---|
| POST | `/api/v1/notifications/push-token` | auth | Register FCM push token for current device |
| POST | `/api/v1/notifications/tokens` | auth | Register APNs/FCM push token (iOS alias) |
| POST | `/api/v1/notifications/test` | auth | Send a test push notification to your own registered devices |
| GET | `/api/v1/notifications` | auth | Get notification feed (paginated) |
| POST | `/api/v1/notifications/{id}/read` | auth | Mark a notification as read |
| POST | `/api/v1/notifications/read-all` | auth | Mark all notifications as read |

## Privacy (5)

| Method | Path | Auth | Summary |
|---|---|---|---|
| GET | `/api/v1/privacy/preferences` | auth | Get privacy preferences |
| PATCH | `/api/v1/privacy/consent` | auth | Update consent settings (GDPR Article 7) |
| GET | `/api/v1/privacy/export` | auth | Export all user data (GDPR Article 20 - Data Portability) |
| PATCH | `/api/v1/privacy/rectify` | auth | Rectify personal data (GDPR Article 16) |
| POST | `/api/v1/privacy/delete` | auth | Delete account (GDPR Article 17 - Right to Erasure) |

## Share (2)

| Method | Path | Auth | Summary |
|---|---|---|---|
| POST | `/api/v1/share/token` | auth | Generate a share token for an entity |
| GET | `/api/v1/share/resolve/{token}` | public | Resolve a share token to its entity |

## Support (5)

| Method | Path | Auth | Summary |
|---|---|---|---|
| POST | `/api/v1/support/tickets` | auth | Create a new support ticket |
| GET | `/api/v1/support/tickets` | auth | Get user's support tickets |
| GET | `/api/v1/support/tickets/{id}` | auth | Get support ticket details |
| POST | `/api/v1/support/tickets/{id}/reply` | auth | Add a reply to a support ticket |
| POST | `/api/v1/support/tickets/{id}/close` | auth | Close a support ticket |

## Translation (4)

| Method | Path | Auth | Summary |
|---|---|---|---|
| GET | `/api/v1/translation/strings` | public | Get localized strings |
| GET | `/api/v1/translation/languages` | public | Get available languages |
| GET | `/api/v1/translation/profile` | auth | Get profile page content (backward compatibility) |
| GET | `/api/v1/translation/detect` | public | Detect language from Accept-Language header |

## Upload (4)

| Method | Path | Auth | Summary |
|---|---|---|---|
| POST | `/api/v1/upload/image` | auth | Upload a profile image |
| POST | `/api/v1/upload/event-banner` | auth | Upload an event banner image |
| POST | `/api/v1/upload/blog-image` | auth | Upload a blog image |
| POST | `/api/v1/upload/nft-image` | auth | Upload an NFT image |

## Users (21)

| Method | Path | Auth | Summary |
|---|---|---|---|
| GET | `/api/v1/users/profile` | auth | Get current user profile |
| PUT | `/api/v1/users/profile` | auth | Update current user profile (full update) |
| GET | `/api/v1/users/me/stats` | auth | Consolidated activity stats for the current user (History & Statistics) |
| GET | `/api/v1/users/me/stats/monthly` | auth | Month-by-month activity for the History & Statistics chart |
| GET | `/api/v1/users/check-username` | auth | Check if a username is available (case-insensitive) |
| PATCH | `/api/v1/users/{id}/profile` | auth | Update user profile by ID (partial update) |
| GET | `/api/v1/users/referral-code` | auth | Get current user referral code |
| GET | `/api/v1/users/{id}/referral-code` | auth | Get user referral code by ID |
| GET | `/api/v1/users/referral-code/{code}/validate` | auth | Validate a referral code |
| GET | `/api/v1/users/referrals` | auth | Get users referred by current user |
| GET | `/api/v1/users/{id}/host-profile` | auth | Get host profile card (public — ratings, stats, recent reviews) |
| GET | `/api/v1/users/{id}` | auth | Get user by ID |
| GET | `/api/v1/users/{id}/qr` | auth | Generate QR code for user identity (for event check-in) |
| GET | `/api/v1/users/{id}/rewards` | auth | Get user reward/badge status |
| GET | `/api/v1/users/{id}/profile-completeness` | auth | Get user profile completeness |
| POST | `/api/v1/users/{id}/follow` | auth | Follow a user |
| DELETE | `/api/v1/users/{id}/follow` | auth | Unfollow a user |
| GET | `/api/v1/users/{id}/followers` | auth | Get user followers |
| GET | `/api/v1/users/{id}/following` | auth | Get users this user is following |
| GET | `/api/v1/users/{id}/follow-stats` | auth | Get follow statistics for a user |
| GET | `/api/v1/users/follow/suggestions` | auth | Get follow suggestions based on shared hobbies |

## beta (4)

| Method | Path | Auth | Summary |
|---|---|---|---|
| POST | `/api/v1/beta/validate` | public | Check whether a beta invite code is currently valid (public) |
| POST | `/api/v1/beta/codes` | auth | Create a beta invite code (admin) |
| GET | `/api/v1/beta/codes` | auth | List beta invite codes (admin) |
| DELETE | `/api/v1/beta/codes/{id}` | auth | Deactivate a beta invite code (admin) |

## cart (5)

| Method | Path | Auth | Summary |
|---|---|---|---|
| GET | `/api/v1/cart` | auth | Get my cart |
| DELETE | `/api/v1/cart` | auth | Clear entire cart |
| POST | `/api/v1/cart/items` | auth | Add item to cart |
| PUT | `/api/v1/cart/items/{id}` | auth | Update cart item quantity |
| DELETE | `/api/v1/cart/items/{id}` | auth | Remove item from cart |

## chat (6)

| Method | Path | Auth | Summary |
|---|---|---|---|
| GET | `/api/v1/events/{eventId}/chat/status` | auth | Get event chat room status |
| POST | `/api/v1/events/{eventId}/chat/create` | auth | Create event chat room (host only) |
| POST | `/api/v1/events/{eventId}/chat/join` | auth | Join event chat |
| GET | `/api/v1/events/{eventId}/chat/messages` | auth | Get chat messages (paginated) |
| POST | `/api/v1/events/{eventId}/chat/messages` | auth | Send a chat message |
| GET | `/api/v1/chat/rooms` | auth | Get all chat rooms for current user |

## cms (7)

| Method | Path | Auth | Summary |
|---|---|---|---|
| GET | `/api/v1/cms/pages` | public | Get all published CMS pages |
| GET | `/api/v1/cms/pages/slug/{slug}` | public | Get CMS page by slug |
| GET | `/api/v1/cms/admin/pages` | auth | Get all CMS pages including unpublished (admin) |
| POST | `/api/v1/cms/admin/pages` | auth | Create a CMS page (admin only) |
| GET | `/api/v1/cms/admin/pages/{id}` | auth | Get CMS page by ID (admin) |
| PUT | `/api/v1/cms/admin/pages/{id}` | auth | Update a CMS page (admin only) |
| DELETE | `/api/v1/cms/admin/pages/{id}` | auth | Delete a CMS page (admin only) |

## dev (7)

| Method | Path | Auth | Summary |
|---|---|---|---|
| POST | `/api/v1/dev/seed` | public | ⚠️ Create demo seed data (TEMPORARY) |
| DELETE | `/api/v1/dev/seed` | public | ⚠️ Delete demo data |
| GET | `/api/v1/dev/check` | public | Check if demo data exists |
| POST | `/api/v1/dev/escrow/simulate` | public | 🎯 DEMO: Create REAL Stripe payment + escrow flow |
| POST | `/api/v1/dev/escrow/checkin` | public | 🎯 DEMO: Simulate check-in (attendance verified) |
| POST | `/api/v1/dev/escrow/release` | public | 🎯 DEMO: Release escrow funds to host |
| GET | `/api/v1/dev/escrow/status` | public | 📊 DEMO: Check current escrow status |

## discounts (7)

| Method | Path | Auth | Summary |
|---|---|---|---|
| POST | `/api/v1/discounts/validate` | auth | Validate a discount code |
| GET | `/api/v1/discounts/rewards` | auth | Get user available reward discounts |
| POST | `/api/v1/discounts` | auth | Create discount code (Admin) |
| GET | `/api/v1/discounts` | auth | List discount codes (Admin) |
| GET | `/api/v1/discounts/{code}` | auth | Get discount code details (Admin) |
| PUT | `/api/v1/discounts/{code}` | auth | Update discount code (Admin) |
| DELETE | `/api/v1/discounts/{code}` | auth | Deactivate discount code (Admin) |

## event-plans (6)

| Method | Path | Auth | Summary |
|---|---|---|---|
| GET | `/api/v1/event-plans` | public | List active create-event capacity plans (public) |
| POST | `/api/v1/event-plans` | auth | Create a capacity tier (admin) |
| GET | `/api/v1/event-plans/quote` | public | Price to create an event of a given capacity (public) |
| GET | `/api/v1/event-plans/admin/all` | auth | List all tiers incl. inactive (admin) |
| PATCH | `/api/v1/event-plans/{id}` | auth | Update a capacity tier / its price (admin) |
| DELETE | `/api/v1/event-plans/{id}` | auth | Delete a capacity tier (admin) |

## events (19)

| Method | Path | Auth | Summary |
|---|---|---|---|
| POST | `/api/v1/events` | auth | Create event (Host only) |
| GET | `/api/v1/events` | public | List events with filters (cursor-based pagination) |
| GET | `/api/v1/events/recommendations` | auth | Get AI-powered personalised event recommendations |
| GET | `/api/v1/events/{id}` | public | Get event details by ID |
| POST | `/api/v1/events/{id}/join` | auth | Join event (triggers matching) |
| POST | `/api/v1/events/{id}/cancel` | auth | Cancel event (host only) |
| GET | `/api/v1/events/{id}/guests` | auth | Get event guest list (host only) |
| POST | `/api/v1/events/{id}/checkin/host-scan` | auth | Host scans guest QR to check in |
| POST | `/api/v1/events/{id}/checkin/self` | auth | Self check-in via GPS (≤2km) |
| POST | `/api/v1/events/{id}/finalize-matches` | auth | Finalize all matches and create chat (host only) |
| POST | `/api/v1/events/participations/{participationId}/finalize` | auth | Finalize single match (host only) |
| POST | `/api/v1/events/{id}/ratings` | auth | Rate an event (verified attendees only, event must have ended) |
| GET | `/api/v1/events/{id}/ratings` | public | Get event ratings (paginated) |
| GET | `/api/v1/events/{id}/ratings/mine` | auth | Get my rating for this event |
| GET | `/api/v1/events/{id}/ratings/summary` | public | Get advanced ratings summary (averages, distribution, sub-ratings) |
| PUT | `/api/v1/events/{id}/ratings/{ratingId}` | auth | Update your event rating |
| DELETE | `/api/v1/events/{id}/ratings/{ratingId}` | auth | Delete your event rating |
| POST | `/api/v1/events/{id}/reports` | auth | Report an event |
| GET | `/api/v1/events/{id}/reports` | auth | Get event reports (admin only) |

## hobbies (6)

| Method | Path | Auth | Summary |
|---|---|---|---|
| GET | `/api/v1/hobbies/categories` | public | Get all hobby categories |
| GET | `/api/v1/hobbies/categories/{id}/hobbies` | public | Get hobbies by category |
| GET | `/api/v1/hobbies/users/{id}` | auth | Get user hobby preferences |
| PUT | `/api/v1/hobbies/users/{id}` | auth | Update user hobby preferences |
| POST | `/api/v1/hobbies/seed` | auth | Seed default hobbies (Admin only) |
| POST | `/api/v1/hobbies/seed-icons` | auth | Patch icon + color on existing hobby categories (Admin only) |

## legal (7)

| Method | Path | Auth | Summary |
|---|---|---|---|
| GET | `/api/v1/legal` | public | Get all active legal documents |
| GET | `/api/v1/legal/type/{type}` | public | Get legal document by type (guidelines, terms, privacy_policy) |
| GET | `/api/v1/legal/admin` | auth | Get all legal documents including inactive (admin) |
| POST | `/api/v1/legal/admin` | auth | Create a legal document (admin only) |
| GET | `/api/v1/legal/admin/{id}` | auth | Get legal document by ID (admin) |
| PUT | `/api/v1/legal/admin/{id}` | auth | Update a legal document (admin only) |
| DELETE | `/api/v1/legal/admin/{id}` | auth | Delete a legal document (admin only) |

## media (1)

| Method | Path | Auth | Summary |
|---|---|---|---|
| POST | `/api/v1/media/upload-url` | auth | Get a pre-signed upload URL for direct media upload to storage |

## newsletter (4)

| Method | Path | Auth | Summary |
|---|---|---|---|
| POST | `/api/v1/newsletter/subscribe` | public | Subscribe an email to the newsletter (public) |
| GET | `/api/v1/newsletter/unsubscribe` | public | Unsubscribe via emailed token (public) |
| GET | `/api/v1/newsletter/subscribers` | auth | List newsletter subscribers (admin) |
| POST | `/api/v1/newsletter/broadcast` | auth | Send the newsletter to all subscribers (admin) |

## payments (14)

| Method | Path | Auth | Summary |
|---|---|---|---|
| POST | `/api/v1/payments/confirm` | auth | Confirm a Stripe payment after client-side confirmation |
| POST | `/api/v1/payments/event` | auth | Create payment intent for event participation |
| POST | `/api/v1/payments/event-creation/{eventId}` | auth | Checkout for the host's create-event capacity plan |
| GET | `/api/v1/payments/history` | auth | Get payment history |
| GET | `/api/v1/payments/{id}/escrow` | auth | Get escrow status for a payment |
| POST | `/api/v1/payments/paypal/create-order` | auth | Create a PayPal order for event payment |
| POST | `/api/v1/payments/paypal/capture/{orderId}` | auth | Capture a PayPal order after user approval |
| GET | `/api/v1/payments/paypal/status/{orderId}` | auth | Get PayPal order status |
| POST | `/api/v1/payments/paypal/vault/setup-token` | auth | Create a PayPal vault setup token |
| POST | `/api/v1/payments/cards/setup-intent` | auth | Create a Stripe SetupIntent to tokenize a new card |
| POST | `/api/v1/payments/cards` | auth | Save a card to the user profile after Stripe tokenization |
| GET | `/api/v1/payments/cards` | auth | List all saved cards for the current user |
| PATCH | `/api/v1/payments/cards/{id}/default` | auth | Set a card as the default payment method |
| DELETE | `/api/v1/payments/cards/{id}` | auth | Remove a saved card from profile and detach from Stripe |

## products (5)

| Method | Path | Auth | Summary |
|---|---|---|---|
| GET | `/api/v1/products` | public | Get all products (public) |
| POST | `/api/v1/products` | auth | Create a product (admin only) |
| GET | `/api/v1/products/{idOrSlug}` | public | Get product by ID or slug |
| PUT | `/api/v1/products/{id}` | auth | Update a product (admin only) |
| DELETE | `/api/v1/products/{id}` | auth | Delete a product (admin only) |

## refunds (5)

| Method | Path | Auth | Summary |
|---|---|---|---|
| GET | `/api/v1/refunds/eligibility/{paymentId}` | auth | Check refund eligibility for a payment |
| POST | `/api/v1/refunds` | auth | Request a refund |
| GET | `/api/v1/refunds/my-requests` | auth | Get my refund requests |
| GET | `/api/v1/refunds/pending` | auth | Get pending refund requests (Admin) |
| POST | `/api/v1/refunds/process` | auth | Process refund request (Admin) |

## subscriptions (6)

| Method | Path | Auth | Summary |
|---|---|---|---|
| GET | `/api/v1/subscriptions/tiers` | public | Get available subscription tiers |
| GET | `/api/v1/subscriptions/status` | auth | Get current subscription status |
| POST | `/api/v1/subscriptions` | auth | Create new subscription (returns a PaymentIntent client secret for in-app payment) |
| DELETE | `/api/v1/subscriptions` | auth | Cancel subscription |
| POST | `/api/v1/subscriptions/resume` | auth | Resume subscription pending cancellation |
| GET | `/api/v1/subscriptions/history` | auth | Get subscription history |

## tickets (6)

| Method | Path | Auth | Summary |
|---|---|---|---|
| POST | `/api/v1/tickets/events/{id}` | auth | Generate a guest ticket for an event |
| GET | `/api/v1/tickets/events/{id}` | auth | Get tickets for an event (organizer only) |
| GET | `/api/v1/tickets/my` | auth | Get my tickets |
| GET | `/api/v1/tickets/{id}` | auth | Get ticket details |
| DELETE | `/api/v1/tickets/{id}` | auth | Cancel a ticket |
| POST | `/api/v1/tickets/{id}/validate` | auth | Validate a ticket (organizer only) |

## users (1)

| Method | Path | Auth | Summary |
|---|---|---|---|
| GET | `/api/v1/users/{id}/attendance` | auth | Get user attendance history |
