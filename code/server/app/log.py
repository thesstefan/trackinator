from flask import has_request_context, request
from flask.logging import default_handler
import flask
import logging
import uuid
from typing import Optional


def generate_request_id(original_id: Optional[str] = None) -> str:
    if original_id:
        return '{}, {}'.format(original_id, uuid.uuid4())

    return str(uuid.uuid4())


def request_id(request: flask.Request) -> str:
    headers = request.headers
    original_request_id = headers.get('X-Request-Id') or None

    return generate_request_id(original_request_id)


class RequestFormatter(logging.Formatter):
    def format(self, record: logging.LogRecord) -> str:
        if has_request_context():
            record.url = request.url
            record.remote_addr = request.remote_addr
        else:
            record.url = None
            record.remote_addr = None

        return super().format(record)


formatter = RequestFormatter(
    '[%(asctime)s] %(remote_addr)s requested %(url)s\n'
    '%(levelname)s in %(module)s: %(message)s'
)
