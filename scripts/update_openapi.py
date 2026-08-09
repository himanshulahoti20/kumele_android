import json

def update_openapi():
    with open('AI/api-reference/openapi.json', 'r') as f:
        data = json.load(f)

    paths = data.get('paths', {})

    # NOTE: The real backend exposes GET /api/v1/events/recommendations.
    # Do NOT rename it to /recommendations/events (returns 404) and do NOT
    # fabricate /match/events — those routes do not exist on the live backend.

    # Add /api/v1/recommendations/hobbies
    # Copy from openapi_ml.json or just create a simple one
    paths['/api/v1/recommendations/hobbies'] = {
        "get": {
            "summary": "Get hobby recommendations",
            "operationId": "HobbiesController_getRecommendationsHobbies_v1",
            "parameters": [
                {"name": "limit", "in": "query", "required": False, "schema": {"type": "integer", "default": 10}}
            ],
            "responses": {
                "200": {
                    "description": "Successful Response",
                    "content": {
                        "application/json": {
                            "schema": {
                                "type": "object",
                                "properties": {
                                    "recommended_hobbies": {
                                        "type": "array",
                                        "items": {"type": "object"}
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    data['paths'] = paths
    
    with open('AI/api-reference/openapi.json', 'w') as f:
        json.dump(data, f, indent=2)

if __name__ == "__main__":
    update_openapi()
