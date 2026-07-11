from __future__ import annotations

import json
from dataclasses import dataclass
from pathlib import Path


@dataclass(frozen=True)
class ServerConfig:
    host: str
    port: int
    booth_network_host: str
    booth_network_port: int
    server_name: str
    version: str
    event_storage_dir: str
    gallery_storage_dir: str
    asset_storage_dir: str
    template_storage_dir: str

    @property
    def local_base_url(self) -> str:
        host = '127.0.0.1' if self.host == '0.0.0.0' else self.host
        return f'http://{host}:{self.port}'

    @property
    def bind_base_url(self) -> str:
        return f'http://{self.host}:{self.port}'

    @property
    def booth_base_url(self) -> str:
        return f'http://{self.booth_network_host}:{self.booth_network_port}'


def load_config(config_path: str | Path | None = None) -> ServerConfig:
    path = Path(config_path) if config_path else Path(__file__).resolve().parents[1] / 'config' / 'server_config.json'
    data = json.loads(path.read_text(encoding='utf-8'))
    return ServerConfig(
        host=data.get('host', '0.0.0.0'),
        port=int(data.get('port', 8080)),
        booth_network_host=data.get('booth_network_host', '192.168.4.1'),
        booth_network_port=int(data.get('booth_network_port', 8080)),
        server_name=data.get('server_name', 'MyBooth Server'),
        version=data.get('version', 'v0.21'),
        event_storage_dir=data.get('event_storage_dir', 'storage/events'),
        gallery_storage_dir=data.get('gallery_storage_dir', 'storage/gallery'),
        asset_storage_dir=data.get('asset_storage_dir', 'storage/assets'),
        template_storage_dir=data.get('template_storage_dir', 'storage/templates'),
    )
