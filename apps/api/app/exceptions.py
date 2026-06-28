from fastapi import HTTPException, Request
from fastapi.exceptions import RequestValidationError
from fastapi.responses import JSONResponse


class KuttiompAPIError(HTTPException):
    """Base API error with structured response."""

    def __init__(self, status_code: int, code: str, message: str, details: dict | None = None):
        super().__init__(status_code=status_code, detail=message)
        self.code = code
        self.message = message
        self.details = details or {}


class NotFoundError(KuttiompAPIError):
    def __init__(self, resource: str, identifier: str | None = None):
        msg = f"{resource} not found"
        if identifier:
            msg = f"{resource} '{identifier}' not found"
        super().__init__(404, "NOT_FOUND", msg)


class ValidationFailedError(KuttiompAPIError):
    def __init__(self, message: str, details: dict | None = None):
        super().__init__(422, "VALIDATION_ERROR", message, details)


class SacredContentError(KuttiompAPIError):
    def __init__(self, message: str = "Sacred content cannot be exposed via this endpoint"):
        super().__init__(403, "SACRED_CONTENT_RESTRICTED", message)


async def kuttiomp_exception_handler(request: Request, exc: KuttiompAPIError):
    return JSONResponse(
        status_code=exc.status_code,
        content={
            "error": {
                "code": exc.code,
                "message": exc.message,
                "details": exc.details,
            }
        },
    )


async def validation_exception_handler(request: Request, exc: RequestValidationError):
    errors = [
        {"field": ".".join(str(l) for l in e["loc"]), "message": e["msg"]}
        for e in exc.errors()
    ]
    return JSONResponse(
        status_code=422,
        content={
            "error": {
                "code": "VALIDATION_ERROR",
                "message": "Request validation failed",
                "details": {"errors": errors},
            }
        },
    )