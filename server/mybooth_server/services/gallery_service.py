from __future__ import annotations

from mybooth_server.models import ModuleStatus


class GalleryService:
    key = 'gallery'
    name = 'Local Gallery Storage'

    def status(self) -> ModuleStatus:
        return ModuleStatus(
            key=self.key,
            name=self.name,
            status='Guest gallery foundation ready',
            message='QR routes target final bordered guest outputs. Raw originals remain operator-only.',
        )

    def qr_delivery_plan(self) -> dict:
        return {
            'guestQrTarget': 'final_bordered_session_gallery',
            'guestVisibleFiles': [
                'gallery/final/session_strip_or_grid.jpg',
                'gallery/qr/session_qr.png',
            ],
            'operatorOnlyFiles': [
                'captures/original',
                'captures/processed',
                'captures/composited',
                'prints/strips',
                'logs',
            ],
            'googlePhotosFutureRule': 'Upload final guest-ready bordered outputs to the event album. Do not upload raw originals by default.',
        }

    def session_gallery_plan(self, session_id: str = 'demo-session') -> dict:
        safe_session_id = session_id.strip('/') or 'demo-session'
        return {
            'sessionId': safe_session_id,
            'title': 'Guest Session Gallery',
            'guestUrl': f'/gallery/session/{safe_session_id}',
            'guestVisibleFiles': [
                {
                    'kind': 'final_guest_output',
                    'title': 'Final bordered strip or grid',
                    'path': f'gallery/final/{safe_session_id}_final.jpg',
                    'downloadEnabled': False,
                },
                {
                    'kind': 'qr_code',
                    'title': 'Session QR code',
                    'path': f'gallery/qr/{safe_session_id}_qr.png',
                    'downloadEnabled': False,
                },
            ],
            'operatorOnlyFolders': [
                'captures/original',
                'captures/processed',
                'captures/composited',
                'prints/strips',
                'logs',
            ],
            'deliveryRule': 'Guest galleries expose final bordered/composited outputs only. Raw/original Canon captures remain operator-only.',
            'googlePhotosExportRule': 'Future Google Photos exports should upload final guest-ready outputs to the event album only.',
        }
