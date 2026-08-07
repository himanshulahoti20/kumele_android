import re

# 1. Update generated_api_catalog.dart
with open('lib/shared/services/api_service/generated/generated_api_catalog.dart', 'r') as f:
    content = f.read()

# Replace EventsController_getRecommendations_v1 with EventsController_getRecommendationsEvents_v1
content = content.replace('EventsController_getRecommendations_v1', 'EventsController_getRecommendationsEvents_v1')
content = content.replace('path: "/events/recommendations"', 'path: "/recommendations/events"')

# Add match events to catalog
match_event = """
  static const GeneratedApiDescriptor EventsController_getMatchEvents_v1 = GeneratedApiDescriptor(
      operationId: "EventsController_getMatchEvents_v1",
      path: "/match/events",
      method: "get",
      requiresAuth: true,
      summary: "Get matched events for Explore/Discover",
  );
"""
# Add hobbies to catalog
hobbies_event = """
  static const GeneratedApiDescriptor HobbiesController_getRecommendationsHobbies_v1 = GeneratedApiDescriptor(
      operationId: "HobbiesController_getRecommendationsHobbies_v1",
      path: "/recommendations/hobbies",
      method: "get",
      requiresAuth: true,
      summary: "Get hobby recommendations",
  );
"""

# Insert before the last closing brace
content = content.replace('}', match_event + hobbies_event + '}')

with open('lib/shared/services/api_service/generated/generated_api_catalog.dart', 'w') as f:
    f.write(content)

# 2. Update generated_api_catalog_lookup.dart
with open('lib/shared/services/api_service/generated/generated_api_catalog_lookup.dart', 'r') as f:
    content2 = f.read()

content2 = content2.replace('EventsController_getRecommendations_v1', 'EventsController_getRecommendationsEvents_v1')

new_lookups = """
  static GeneratedApiDescriptor get getMatchEvents =>
      require('EventsController_getMatchEvents_v1');

  static GeneratedApiDescriptor get getRecommendationsHobbies =>
      require('HobbiesController_getRecommendationsHobbies_v1');
"""

# Find a good place to insert (e.g. before the last closing brace in GeneratedApiOperations)
content2 = content2.replace('}', new_lookups + '}')

with open('lib/shared/services/api_service/generated/generated_api_catalog_lookup.dart', 'w') as f:
    f.write(content2)

