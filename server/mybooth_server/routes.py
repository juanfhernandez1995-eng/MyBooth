from __future__ import annotations

import json
from http import HTTPStatus
from typing import Any

from .config import ServerConfig
from .models import ServerHealth, utc_now_iso
from .services.ai_service import AiService
from .services.asset_library_service import AssetLibraryService
from .services.camera_service import CameraService
from .services.event_storage_service import EventStorageService
from .services.gallery_service import GalleryService
from .services.photo_storage_service import PhotoStorageService
from .services.printer_service import PrinterService


def json_response(handler, payload: dict[str, Any], status: HTTPStatus = HTTPStatus.OK) -> None:
    body = json.dumps(payload, indent=2).encode('utf-8')
    handler.send_response(status.value)
    handler.send_header('Content-Type', 'application/json; charset=utf-8')
    handler.send_header('Content-Length', str(len(body)))
    handler.send_header('Access-Control-Allow-Origin', '*')
    handler.end_headers()
    handler.wfile.write(body)


def module_payload() -> list[dict[str, Any]]:
    services = [
        CameraService(),
        PrinterService(),
        AiService(),
        GalleryService(),
        EventStorageService(),
    ]
    return [service.status().to_dict() for service in services]


def handle_get(path: str, config: ServerConfig, handler) -> None:
    if path == '/health':
        health = ServerHealth(
            ok=True,
            server_name=config.server_name,
            version=config.version,
            timestamp_utc=utc_now_iso(),
        )
        json_response(handler, health.to_dict())
        return

    if path == '/status':
        json_response(handler, {
            'ok': True,
            'serverName': config.server_name,
            'version': config.version,
            'localBaseUrl': config.local_base_url,
            'boothBaseUrl': config.booth_base_url,
            'modules': module_payload(),
            'timestampUtc': utc_now_iso(),
        })
        return

    if path == '/modules':
        json_response(handler, {'modules': module_payload(), 'timestampUtc': utc_now_iso()})
        return

    if path == '/assets/templates':
        templates = [template.to_dict() for template in AssetLibraryService().templates()]
        json_response(handler, {'templates': templates, 'timestampUtc': utc_now_iso()})
        return

    if path == '/assets/backgrounds':
        backgrounds = [pack.to_dict() for pack in AssetLibraryService().background_packs()]
        json_response(handler, {'backgroundPacks': backgrounds, 'timestampUtc': utc_now_iso()})
        return

    if path == '/assets/template-designer-plan':
        json_response(handler, {'templateDesignerPlan': AssetLibraryService().template_designer_plan(), 'timestampUtc': utc_now_iso()})
        return

    if path == '/storage/photo-plan':
        json_response(handler, {'photoStoragePlan': PhotoStorageService().storage_plan().to_dict(), 'timestampUtc': utc_now_iso()})
        return

    if path == '/gallery/qr-plan':
        json_response(handler, {'qrDeliveryPlan': GalleryService().qr_delivery_plan(), 'timestampUtc': utc_now_iso()})
        return

    if path == '/gallery/session/demo':
        json_response(handler, {'sessionGallery': GalleryService().session_gallery_plan('demo-session'), 'timestampUtc': utc_now_iso()})
        return

    if path.startswith('/gallery/session/'):
        session_id = path.removeprefix('/gallery/session/').strip() or 'demo-session'
        json_response(handler, {'sessionGallery': GalleryService().session_gallery_plan(session_id), 'timestampUtc': utc_now_iso()})
        return


    if path == '/booth/session-review-plan':
        json_response(handler, {
            'sessionReviewPlan': {
                'sequence': [
                    'capture_photos',
                    'processing_preview',
                    'review_and_approve',
                    'retake_or_start_over',
                    'select_print_quantity',
                    'show_guest_qr_gallery',
                ],
                'approvalActions': ['approve', 'retake_last_photo', 'start_over'],
                'printOptions': {
                    'minCopies': 1,
                    'maxCopies': 6,
                    'allowSkipPrint': True,
                    'defaultSource': 'event.printCopies',
                },
                'guestDeliveryRule': 'QR opens final bordered/composited guest gallery after approval.',
                'operatorBoundary': 'Raw/original captures remain operator-only and are not exposed through the guest QR.',
            },
            'timestampUtc': utc_now_iso(),
        })
        return

    json_response(handler, {'ok': False, 'error': 'Route not found', 'path': path}, HTTPStatus.NOT_FOUND)


def handle_post(path: str, body: dict[str, Any], config: ServerConfig, handler) -> None:
    if path == '/pair':
        tablet_name = str(body.get('tabletName', 'Android Tablet'))
        json_response(handler, {
            'ok': True,
            'message': 'Mock pairing accepted. Real pairing security will be added in a later release.',
            'tabletName': tablet_name,
            'serverName': config.server_name,
            'version': config.version,
            'timestampUtc': utc_now_iso(),
        })
        return


    if path == '/booth/session-review-plan':
        json_response(handler, {
            'sessionReviewPlan': {
                'sequence': [
                    'capture_photos',
                    'processing_preview',
                    'review_and_approve',
                    'retake_or_start_over',
                    'select_print_quantity',
                    'show_guest_qr_gallery',
                ],
                'approvalActions': ['approve', 'retake_last_photo', 'start_over'],
                'printOptions': {
                    'minCopies': 1,
                    'maxCopies': 6,
                    'allowSkipPrint': True,
                    'defaultSource': 'event.printCopies',
                },
                'guestDeliveryRule': 'QR opens final bordered/composited guest gallery after approval.',
                'operatorBoundary': 'Raw/original captures remain operator-only and are not exposed through the guest QR.',
            },
            'timestampUtc': utc_now_iso(),
        })
        return

    json_response(handler, {'ok': False, 'error': 'Route not found', 'path': path}, HTTPStatus.NOT_FOUND)
