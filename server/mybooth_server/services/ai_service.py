from __future__ import annotations

from mybooth_server.models import ModuleStatus


class AiService:
    key = 'ai_engine'
    name = 'AI Background Engine'

    def status(self) -> ModuleStatus:
        return ModuleStatus(
            key=self.key,
            name=self.name,
            status='Integration planned',
            message='AI workflow service boundary is ready. Background replacement is not connected yet.',
        )
