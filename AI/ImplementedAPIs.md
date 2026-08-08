# Kumele Flutter Android — Implemented APIs

**Audit Date:** 2026-08-08

This document tracks API implementation status in the **Kumele Flutter Android application**.

## Important

This is **NOT** the iOS/Swift project documentation. This tracks the **Flutter/Android** implementation.

The iOS Swift project has its own separate API tracking document at `AI/05_ImplementedAPIs.md` which tracks the Swift/iOS implementation.

## Summary

- **Total API Operations:** 203
- **Consumer-Relevant:** 169
- **Admin/Business-Only (Excluded):** 34
- **Implemented:** 57
  - With UI Integration: 38
  - Without UI: 19
- **Not Implemented:** 112

## Status Legend

- 🟢 **Implemented & Live** — API call exists and is used in the app
- ⚪ **Implemented but No UI** — API method exists but has no UI integration
- ❌ **Not Implemented** — No implementation exists
- 🚫 **Admin/Business Only** — Excluded from consumer app (not needed)

---

## 26. AUTH

**Status:** 16/26 implemented (8 missing, 2 admin-only)

| Status | Method | Endpoint | Summary |
|--------|--------|----------|---------|
| 🟢 | POST | `/auth/2fa/disable` | Disable 2FA |
| 🟢 | POST | `/auth/2fa/enable` | Enable 2FA after verifying a TOTP code |
| 🟢 | POST | `/auth/2fa/setup` | Set up 2FA — returns QR code and secret |
| 🟢 | POST | `/auth/2fa/verify` | Complete 2FA login with TOTP code |
| 🟢 | POST | `/auth/change-password` | Change password (authenticated) |
| 🟢 | POST | `/auth/firebase-login` | Firebase token login (Flutter / mobile) |
| 🟢 | POST | `/auth/forgot-password` | Request password reset OTP (sent to email) |
| ❌ | GET | `/auth/google` | Initiate Google OAuth login |
| ❌ | GET | `/auth/google/callback` | Google OAuth callback |
| 🟢 | POST | `/auth/login` | Login with email and password |
| 🟢 | POST | `/auth/logout` | Logout current session |
| ❌ | POST | `/auth/logout-all` | Logout from all devices |
| ❌ | GET | `/auth/me` | Get current authenticated user |
| 🟢 | POST | `/auth/passkey/login/finish` | Complete passkey login |
| 🟢 | POST | `/auth/passkey/login/start` | Start passkey login |
| ❌ | POST | `/auth/passkey/register/finish` | Complete passkey registration |
| ❌ | POST | `/auth/passkey/register/start` | Start passkey registration |
| ❌ | POST | `/auth/refresh` | Refresh access token |
| ❌ | POST | `/auth/resend-verification` | Resend verification email |
| 🟢 | POST | `/auth/reset-password` | Reset password using token from /auth/verify-reset-otp |
| 🟢 | POST | `/auth/send-verification-email` | Send email verification OTP |
| 🟢 | POST | `/auth/signup` | Register a new user |
| 🟢 | POST | `/auth/verify-email` | Verify email with OTP code |
| 🟢 | POST | `/auth/verify-reset-otp` | Verify password reset OTP and get a one-time reset token |

## 20. PROFILE

**Status:** 6/20 implemented (14 missing, 0 admin-only)

| Status | Method | Endpoint | Summary |
|--------|--------|----------|---------|
| 🟢 | GET | `/users/check-username` | Check if a username is available (case-insensitive) |
| ❌ | GET | `/users/follow/suggestions` | Get follow suggestions based on shared hobbies |
| ❌ | GET | `/users/profile` | Get current user profile |
| ❌ | PUT | `/users/profile` | Update current user profile (full update) |
| 🟢 | GET | `/users/referral-code` | Get current user referral code |
| 🟢 | GET | `/users/referral-code/{code}/validate` | Validate a referral code |
| ❌ | GET | `/users/referrals` | Get users referred by current user |
| ❌ | GET | `/users/{id}` | Get user by ID |
| ❌ | GET | `/users/{id}/attendance` | Get user attendance history |
| ❌ | DELETE | `/users/{id}/follow` | Unfollow a user |
| ❌ | POST | `/users/{id}/follow` | Follow a user |
| ❌ | GET | `/users/{id}/follow-stats` | Get follow statistics for a user |
| 🟢 | GET | `/users/{id}/followers` | Get user followers |
| 🟢 | GET | `/users/{id}/following` | Get users this user is following |
| ❌ | GET | `/users/{id}/host-profile` | Get host profile card (public — ratings, stats, recent reviews) |
| ❌ | PATCH | `/users/{id}/profile` | Update user profile by ID (partial update) |
| ❌ | GET | `/users/{id}/profile-completeness` | Get user profile completeness |
| 🟢 | GET | `/users/{id}/qr` | Generate QR code for user identity (for event check-in) |
| ❌ | GET | `/users/{id}/referral-code` | Get user referral code by ID |
| ❌ | GET | `/users/{id}/rewards` | Get user reward/badge status |

## 7. HOBBIES

**Status:** 3/7 implemented (2 missing, 2 admin-only)

| Status | Method | Endpoint | Summary |
|--------|--------|----------|---------|
| ❌ | GET | `/hobbies/categories` | Get all hobby categories |
| ❌ | GET | `/hobbies/categories/{id}/hobbies` | Get hobbies by category |
| ⚪ | GET | `/hobbies/users/{id}` | Get user hobby preferences |
| ⚪ | PUT | `/hobbies/users/{id}` | Update user hobby preferences |
| ⚪ | GET | `/recommendations/hobbies` | Get hobby recommendations for the current user |

## 26. EVENTS

**Status:** 8/26 implemented (17 missing, 1 admin-only)

| Status | Method | Endpoint | Summary |
|--------|--------|----------|---------|
| 🟢 | GET | `/chat/rooms` | Get all chat rooms for current user |
| ❌ | GET | `/events` | List events with filters (cursor-based pagination) |
| 🟢 | POST | `/events` | Create event (Host only) |
| ❌ | POST | `/events/participations/{participationId}/finalize` | Finalize single match (host only) |
| ❌ | POST | `/events/{eventId}/chat/create` | Create event chat room (host only) |
| 🟢 | POST | `/events/{eventId}/chat/join` | Join event chat |
| 🟢 | GET | `/events/{eventId}/chat/messages` | Get chat messages (paginated) |
| ❌ | POST | `/events/{eventId}/chat/messages` | Send a chat message |
| 🟢 | GET | `/events/{eventId}/chat/status` | Get event chat room status |
| 🟢 | GET | `/events/{id}` | Get event details by ID |
| ❌ | POST | `/events/{id}/cancel` | Cancel event (host only) |
| ❌ | POST | `/events/{id}/checkin/host-scan` | Host scans guest QR to check in |
| ❌ | POST | `/events/{id}/checkin/self` | Self check-in via GPS (≤2km) |
| ❌ | POST | `/events/{id}/finalize-matches` | Finalize all matches and create chat (host only) |
| ❌ | GET | `/events/{id}/guests` | Get event guest list (host only) |
| 🟢 | POST | `/events/{id}/join` | Join event (triggers matching) |
| ❌ | GET | `/events/{id}/ratings` | Get event ratings (paginated) |
| ❌ | POST | `/events/{id}/ratings` | Rate an event (verified attendees only, event must have ended) |
| ❌ | GET | `/events/{id}/ratings/mine` | Get my rating for this event |
| ❌ | GET | `/events/{id}/ratings/summary` | Get advanced ratings summary (averages, distribution, sub-ratings) |
| ❌ | DELETE | `/events/{id}/ratings/{ratingId}` | Delete your event rating |
| ❌ | PUT | `/events/{id}/ratings/{ratingId}` | Update your event rating |
| ❌ | POST | `/events/{id}/reports` | Report an event |
| 🟢 | GET | `/match/events` | Get matched events for Discover/Explore/nearby (backend-filtered, AI-scored) |
| ❌ | GET | `/recommendations/events` | Get personalised event recommendations (\ |

## 8. BLOGS

**Status:** 1/8 implemented (7 missing, 0 admin-only)

| Status | Method | Endpoint | Summary |
|--------|--------|----------|---------|
| ❌ | POST | `/blogs` | Create a blog post (with markdown processing pipeline) |
| 🟢 | GET | `/blogs/feed` | Get blog feed (cursor-based pagination, approved + visibility filtered) |
| ❌ | GET | `/blogs/public/{slug}` | Get public SEO blog post by slug |
| ❌ | GET | `/blogs/sitemap` | Get list of public SEO blog slugs for sitemap |
| ❌ | GET | `/blogs/{id}` | Get blog post detail by ID (pass JWT to get is_liked) |
| ❌ | GET | `/blogs/{id}/comments` | Get comments for a blog post (cursor-based) |
| ❌ | POST | `/blogs/{id}/comments` | Add a comment to a blog post |
| ❌ | POST | `/blogs/{id}/like` | Toggle like on a blog post |

## 6. NOTIFICATIONS

**Status:** 2/6 implemented (4 missing, 0 admin-only)

| Status | Method | Endpoint | Summary |
|--------|--------|----------|---------|
| 🟢 | GET | `/notifications` | Get notification feed (paginated) |
| 🟢 | POST | `/notifications/push-token` | Register FCM push token for current device |
| ❌ | POST | `/notifications/read-all` | Mark all notifications as read |
| ❌ | POST | `/notifications/test` | Send a test push notification to your own registered devices |
| ❌ | POST | `/notifications/tokens` | Register APNs/FCM push token (iOS alias) |
| ❌ | POST | `/notifications/{id}/read` | Mark a notification as read |

## 6. SUBSCRIPTIONS

**Status:** 5/6 implemented (1 missing, 0 admin-only)

| Status | Method | Endpoint | Summary |
|--------|--------|----------|---------|
| 🟢 | DELETE | `/subscriptions` | Cancel subscription |
| 🟢 | POST | `/subscriptions` | Create new subscription (returns a PaymentIntent client secret for in-app paymen... |
| ❌ | GET | `/subscriptions/history` | Get subscription history |
| 🟢 | POST | `/subscriptions/resume` | Resume subscription pending cancellation |
| 🟢 | GET | `/subscriptions/status` | Get current subscription status |
| 🟢 | GET | `/subscriptions/tiers` | Get available subscription tiers |

## 15. PAYMENTS

**Status:** 7/15 implemented (8 missing, 0 admin-only)

| Status | Method | Endpoint | Summary |
|--------|--------|----------|---------|
| ❌ | GET | `/payments/cards` | List all saved cards for the current user |
| ❌ | POST | `/payments/cards` | Save a card to the user profile after Stripe tokenization |
| ❌ | POST | `/payments/cards/setup-intent` | Create a Stripe SetupIntent to tokenize a new card |
| ❌ | DELETE | `/payments/cards/{id}` | Remove a saved card from profile and detach from Stripe |
| ❌ | PATCH | `/payments/cards/{id}/default` | Set a card as the default payment method |
| ⚪ | POST | `/payments/confirm` | Confirm a Stripe payment after client-side confirmation |
| ⚪ | POST | `/payments/event` | Create payment intent for event participation |
| ⚪ | POST | `/payments/event-creation/{eventId}` | Checkout for the host's create-event capacity plan |
| ⚪ | GET | `/payments/history` | Get payment history |
| ⚪ | POST | `/payments/paypal/capture/{orderId}` | Capture a PayPal order after user approval |
| ⚪ | POST | `/payments/paypal/create-order` | Create a PayPal order for event payment |
| ⚪ | POST | `/payments/paypal/event-creation/{eventId}` | Start a PayPal order for the host's create-event capacity plan |
| ❌ | GET | `/payments/paypal/status/{orderId}` | Get PayPal order status |
| ❌ | POST | `/payments/paypal/vault/setup-token` | Create a PayPal vault setup token |
| ❌ | GET | `/payments/{id}/escrow` | Get escrow status for a payment |

## 6. TICKETS

**Status:** 1/6 implemented (5 missing, 0 admin-only)

| Status | Method | Endpoint | Summary |
|--------|--------|----------|---------|
| ❌ | GET | `/tickets/events/{id}` | Get tickets for an event (organizer only) |
| ❌ | POST | `/tickets/events/{id}` | Generate a guest ticket for an event |
| ⚪ | GET | `/tickets/my` | Get my tickets |
| ❌ | DELETE | `/tickets/{id}` | Cancel a ticket |
| ❌ | GET | `/tickets/{id}` | Get ticket details |
| ❌ | POST | `/tickets/{id}/validate` | Validate a ticket (organizer only) |

## 8. WEB3

**Status:** 3/8 implemented (4 missing, 1 admin-only)

| Status | Method | Endpoint | Summary |
|--------|--------|----------|---------|
| ❌ | GET | `/nfts/marketplace` | Browse NFT marketplace (filterable, paginated) |
| ⚪ | GET | `/nfts/mine` | Get all NFTs owned by the current user |
| ❌ | GET | `/nfts/my-screen` | Get personalized NFT screen (owned, claimable, marketplace, exclusive) |
| ❌ | GET | `/nfts/rewards` | Get all reward NFTs (earned status per user) |
| ❌ | GET | `/nfts/{id}` | Get NFT details by ID |
| ⚪ | POST | `/nfts/{id}/claim` | Claim a free reward NFT |
| ⚪ | POST | `/nfts/{id}/purchase` | Purchase an NFT |

## 2. ADS

**Status:** 2/2 implemented (0 missing, 0 admin-only)

| Status | Method | Endpoint | Summary |
|--------|--------|----------|---------|
| ⚪ | GET | `/ads/fetch` | Fetch ads for display (ML + fallback) |
| ⚪ | POST | `/ads/track` | Track ad view/click/conversion |

## 6. MEDIA

**Status:** 2/6 implemented (4 missing, 0 admin-only)

| Status | Method | Endpoint | Summary |
|--------|--------|----------|---------|
| ❌ | POST | `/media/upload` | Upload image or video |
| ❌ | POST | `/media/upload-url` | Get a pre-signed upload URL for direct media upload to storage |
| ❌ | POST | `/upload/blog-image` | Upload a blog image |
| ⚪ | POST | `/upload/event-banner` | Upload an event banner image |
| ⚪ | POST | `/upload/image` | Upload a profile image |
| ❌ | POST | `/upload/nft-image` | Upload an NFT image |

## 7. LEGAL

**Status:** 0/7 implemented (2 missing, 5 admin-only)

| Status | Method | Endpoint | Summary |
|--------|--------|----------|---------|
| ❌ | GET | `/legal` | Get all active legal documents |
| ❌ | GET | `/legal/type/{type}` | Get legal document by type (guidelines, terms, privacy_policy) |

## 2. LOCALIZATION

**Status:** 0/2 implemented (2 missing, 0 admin-only)

| Status | Method | Endpoint | Summary |
|--------|--------|----------|---------|
| ❌ | GET | `/localization/languages` | Get available languages |
| ❌ | GET | `/localization/strings` | Get localization strings by language |

## 4. TRANSLATION

**Status:** 0/4 implemented (4 missing, 0 admin-only)

| Status | Method | Endpoint | Summary |
|--------|--------|----------|---------|
| ❌ | GET | `/translation/detect` | Detect language from Accept-Language header |
| ❌ | GET | `/translation/languages` | Get available languages |
| ❌ | GET | `/translation/profile` | Get profile page content (backward compatibility) |
| ❌ | GET | `/translation/strings` | Get localized strings |

## 5. PRIVACY

**Status:** 1/5 implemented (4 missing, 0 admin-only)

| Status | Method | Endpoint | Summary |
|--------|--------|----------|---------|
| ❌ | PATCH | `/privacy/consent` | Update consent settings (GDPR Article 7) |
| ⚪ | POST | `/privacy/delete` | Delete account (GDPR Article 17 - Right to Erasure) |
| ❌ | GET | `/privacy/export` | Export all user data (GDPR Article 20 - Data Portability) |
| ❌ | GET | `/privacy/preferences` | Get privacy preferences |
| ❌ | PATCH | `/privacy/rectify` | Rectify personal data (GDPR Article 16) |

## 5. SUPPORT

**Status:** 0/5 implemented (5 missing, 0 admin-only)

| Status | Method | Endpoint | Summary |
|--------|--------|----------|---------|
| ❌ | GET | `/support/tickets` | Get user's support tickets |
| ❌ | POST | `/support/tickets` | Create a new support ticket |
| ❌ | GET | `/support/tickets/{id}` | Get support ticket details |
| ❌ | POST | `/support/tickets/{id}/close` | Close a support ticket |
| ❌ | POST | `/support/tickets/{id}/reply` | Add a reply to a support ticket |

## 5. CART

**Status:** 0/5 implemented (5 missing, 0 admin-only)

| Status | Method | Endpoint | Summary |
|--------|--------|----------|---------|
| ❌ | DELETE | `/cart` | Clear entire cart |
| ❌ | GET | `/cart` | Get my cart |
| ❌ | POST | `/cart/items` | Add item to cart |
| ❌ | DELETE | `/cart/items/{id}` | Remove item from cart |
| ❌ | PUT | `/cart/items/{id}` | Update cart item quantity |

## 5. PRODUCTS

**Status:** 0/5 implemented (2 missing, 3 admin-only)

| Status | Method | Endpoint | Summary |
|--------|--------|----------|---------|
| ❌ | GET | `/products` | Get all products (public) |
| ❌ | GET | `/products/{idOrSlug}` | Get product by ID or slug |

## 7. DISCOUNTS

**Status:** 0/7 implemented (2 missing, 5 admin-only)

| Status | Method | Endpoint | Summary |
|--------|--------|----------|---------|
| ❌ | GET | `/discounts/rewards` | Get user available reward discounts |
| ❌ | POST | `/discounts/validate` | Validate a discount code |

## 5. REFUNDS

**Status:** 0/5 implemented (3 missing, 2 admin-only)

| Status | Method | Endpoint | Summary |
|--------|--------|----------|---------|
| ❌ | POST | `/refunds` | Request a refund |
| ❌ | GET | `/refunds/eligibility/{paymentId}` | Check refund eligibility for a payment |
| ❌ | GET | `/refunds/my-requests` | Get my refund requests |

## 2. SHARE

**Status:** 0/2 implemented (2 missing, 0 admin-only)

| Status | Method | Endpoint | Summary |
|--------|--------|----------|---------|
| ❌ | GET | `/share/resolve/{token}` | Resolve a share token to its entity |
| ❌ | POST | `/share/token` | Generate a share token for an entity |

## 7. CMS

**Status:** 0/7 implemented (2 missing, 5 admin-only)

| Status | Method | Endpoint | Summary |
|--------|--------|----------|---------|
| ❌ | GET | `/cms/pages` | Get all published CMS pages |
| ❌ | GET | `/cms/pages/slug/{slug}` | Get CMS page by slug |

## 2. APP

**Status:** 0/2 implemented (2 missing, 0 admin-only)

| Status | Method | Endpoint | Summary |
|--------|--------|----------|---------|
| ❌ | GET | `/app/config` | Get app configuration (maintenance mode, versions, feature flags) |
| ❌ | GET | `/app/health` | App health check (for load balancers) |

## 3. HEALTH

**Status:** 0/3 implemented (3 missing, 0 admin-only)

| Status | Method | Endpoint | Summary |
|--------|--------|----------|---------|
| ❌ | GET | `/health` | Check application health |
| ❌ | GET | `/health/live` | Liveness probe for Kubernetes |
| ❌ | GET | `/health/ready` | Readiness probe for Kubernetes |

---

## Implementation Notes

### General Architecture

- **API Client:** `lib/shared/services/api_service/api_service.dart`
- **Generated Catalog:** `lib/shared/services/api_service/generated/generated_api_catalog.dart`
- **Repositories:** `lib/features/*/data/repositories/`
- **Remote Data Sources:** `lib/features/*/data/datasources/`

### Key Implemented Features

1. **Authentication (16/24 endpoints)**
   - Email/password login and signup
   - Firebase/Google authentication
   - Passkey authentication (login)
   - 2FA setup, enable, disable, verify
   - Password reset flow (forgot, verify OTP, reset)
   - Email verification

2. **Events (8/25 endpoints)**
   - List events with filters
   - Get event recommendations/matches
   - Create events
   - Join events
   - Chat rooms

3. **Subscriptions (5/6 endpoints)**
   - Get subscription tiers
   - Get subscription status
   - Create, cancel, resume subscriptions

4. **Profile & Social (6/20 endpoints)**
   - Get/update user profile
   - Follow/unfollow users
   - Get followers/following

5. **Payments (7/15 endpoints)**
   - PayPal order creation and capture
   - Payment history
   - Saved cards management

### Major Missing Features

1. **Blog System (7/8 endpoints missing)**
   - Only blog feed is implemented
   - Missing: blog detail, comments, likes

2. **Cart & Products (All endpoints missing)**
   - No shopping cart implementation
   - No product catalog

3. **Support & Tickets (All endpoints missing)**
   - No support ticket system
   - No help/FAQ integration

4. **Event Management (17/25 endpoints missing)**
   - Missing: ratings, reports, check-in, guest management

5. **Notifications (4/6 endpoints missing)**
   - Missing: mark as read, mark all as read, test notifications

6. **Privacy & GDPR (4/5 endpoints missing)**
   - Only account deletion implemented
   - Missing: data export, consent management, rectification

### Recommendations

#### High Priority (Core User Experience)

1. **Blog Detail & Interaction** - Users can see feed but can't read posts
2. **Event Ratings & Reviews** - Critical for social proof
3. **Notifications Read Status** - Basic UX requirement
4. **Profile Completeness** - Better onboarding

#### Medium Priority (Enhanced Features)

1. **Event Check-in** - Host/guest experience
2. **Guest Tickets** - Event attendance tracking
3. **Refunds** - Payment dispute handling
4. **Support Tickets** - User support system

#### Low Priority (Nice to Have)

1. **Shopping Cart** - If product sales are planned
2. **NFT Integration** - If web3 features are prioritized
3. **Translation/Localization** - For international expansion
4. **CMS Integration** - For dynamic content

---

**Generated:** 2026-08-08T19:15:22.937368

**Note:** This audit was performed by automated analysis of the Flutter codebase.
Actual runtime behavior and UI integration may require manual verification.
