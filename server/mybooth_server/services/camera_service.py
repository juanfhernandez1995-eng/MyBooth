from __future__ import annotations

from mybooth_server.models import ModuleStatus


class CameraService:
    key = 'camera'
    name = 'Canon EOS R50'

    def status(self) -> ModuleStatus:
        return ModuleStatus(
            key=self.key,
            name=self.name,
            status='Integration planned',
            message='Camera capture service boundary is ready. Real Canon control is not connected yet.',
        )
