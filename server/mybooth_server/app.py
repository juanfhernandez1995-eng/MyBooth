from __future__ import annotations

import json
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from urllib.parse import urlparse

from .config import load_config
from .routes import handle_get, handle_post, json_response


class MyBoothRequestHandler(BaseHTTPRequestHandler):
    config = load_config()

    def do_GET(self) -> None:
        path = urlparse(self.path).path
        handle_get(path, self.config, self)

    def do_POST(self) -> None:
        path = urlparse(self.path).path
        content_length = int(self.headers.get('Content-Length', '0'))
        raw_body = self.rfile.read(content_length) if content_length else b'{}'
        try:
            body = json.loads(raw_body.decode('utf-8') or '{}')
        except json.JSONDecodeError:
            json_response(self, {'ok': False, 'error': 'Invalid JSON body'})
            return
        handle_post(path, body, self.config, self)

    def do_OPTIONS(self) -> None:
        self.send_response(204)
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
        self.end_headers()

    def log_message(self, format: str, *args) -> None:
        print(f'[MyBooth Server] {self.address_string()} - {format % args}')


def run() -> None:
    config = load_config()
    MyBoothRequestHandler.config = config
    server = ThreadingHTTPServer((config.host, config.port), MyBoothRequestHandler)
    print(f'{config.server_name} {config.version} running on {config.bind_base_url}')
    print(f'Laptop browser test: {config.local_base_url}')
    print(f'Booth network target: {config.booth_base_url}')
    print('Press Ctrl+C to stop.')
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print('Stopping MyBooth Server...')
    finally:
        server.server_close()
