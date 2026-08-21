# Kuttiomp FastAPI — production image.
# Build context must be apps/api (Railway Root Directory = apps/api):
#   docker build -t kuttiomp-api ./apps/api
#
# Runtime: uvicorn app.main:app --host 0.0.0.0 --port $PORT
# Do not bake secrets into the image. Pass env at run / Railway Variables.

FROM python:3.12.13-slim-bookworm

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1 \
    PORT=8000

WORKDIR /app

RUN groupadd --system --gid 10001 app \
    && useradd --system --uid 10001 --gid app --home /app --shell /usr/sbin/nologin app

COPY requirements.txt /tmp/requirements.txt
# Runtime deps only — omit pytest (listed in requirements.txt for local / CI).
RUN grep -v '^pytest' /tmp/requirements.txt > /tmp/requirements.prod.txt \
    && pip install --no-cache-dir -r /tmp/requirements.prod.txt \
    && rm -f /tmp/requirements.txt /tmp/requirements.prod.txt

COPY app ./app

USER app

EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=5s --start-period=40s --retries=3 \
    CMD python -c "import os, urllib.request; urllib.request.urlopen('http://127.0.0.1:%s/health' % os.environ.get('PORT', '8000'))"

CMD ["sh", "-c", "uvicorn app.main:app --host 0.0.0.0 --port ${PORT:-8000}"]
