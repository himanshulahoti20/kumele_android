import json

def update_openapi():
    with open('AI/api-reference/openapi.json', 'r') as f:
        data = json.load(f)

    paths = data.get('paths', {})

    # 1. Rename /api/v1/events/recommendations to /api/v1/recommendations/events
    if '/api/v1/events/recommendations' in paths:
        paths['/api/v1/recommendations/events'] = paths.pop('/api/v1/events/recommendations')
        # Update operationId just in case
        if 'get' in paths['/api/v1/recommendations/events']:
            paths['/api/v1/recommendations/events']['get']['operationId'] = 'EventsController_getRecommendationsEvents_v1'

    # 2. Add /api/v1/match/events
    # We will copy the schema of /api/v1/events but change summary/operationId
    if '/api/v1/events' in paths:
        match_events = json.loads(json.dumps(paths['/api/v1/events']))
        if 'get' in match_events:
            match_events['get']['summary'] = "Get matched events for Explore/Discover"
            match_events['get']['operationId'] = 'EventsController_getMatchEvents_v1'
            # Add lat, lon, radius if not present
            params = match_events['get'].get('parameters', [])
            param_names = [p.get('name') for p in params]
            if 'lat' not in param_names:
                params.append({"name": "lat", "in": "query", "required": False, "schema": {"type": "number"}})
                params.append({"name": "lon", "in": "query", "required": False, "schema": {"type": "number"}})
                params.append({"name": "radius", "in": "query", "required": False, "schema": {"type": "number"}})
            match_events['get']['parameters'] = params
        paths['/api/v1/match/events'] = match_events

    # 3. Add /api/v1/recommendations/hobbies
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
