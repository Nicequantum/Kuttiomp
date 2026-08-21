LEARN_ORIGINS = (
    "https://kuttiomp-learn.vercel.app",
    "http://localhost:8080",
    "http://localhost:3000",
)


def test_cors_allows_learn_origins(client):
    for origin in LEARN_ORIGINS:
        response = client.options(
            "/api/v1/public/lexicon",
            headers={
                "Origin": origin,
                "Access-Control-Request-Method": "GET",
            },
        )
        assert response.headers.get("access-control-allow-origin") == origin, origin
