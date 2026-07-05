from __future__ import annotations

from mybooth_server.models import ModuleStatus


class EventStorageService:
    key = 'event_storage'
    name = 'Event Storage API'

    def status(self) -> ModuleStatus:
        return ModuleStatus(
            key=self.key,
            name=self.name,
            status='Foundation ready',
            message='Event storage API boundary is ready for future session data sync.',
        )
