from __future__ import annotations

from mybooth_server.models import ModuleStatus


class PrinterService:
    key = 'printer'
    name = 'DNP DS-RX1HS'

    def status(self) -> ModuleStatus:
        return ModuleStatus(
            key=self.key,
            name=self.name,
            status='Integration planned',
            message='Printer queue service boundary is ready. DNP printer control is not connected yet.',
        )
