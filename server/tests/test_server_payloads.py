import unittest

from mybooth_server.config import load_config
from mybooth_server.routes import module_payload
from mybooth_server.services.asset_library_service import AssetLibraryService
from mybooth_server.services.gallery_service import GalleryService
from mybooth_server.services.photo_storage_service import PhotoStorageService


class ServerPayloadTests(unittest.TestCase):
    def test_config_loads(self):
        config = load_config()
        self.assertEqual(config.version, 'v0.20')
        self.assertEqual(config.port, 8080)

    def test_module_payload_has_expected_boundaries(self):
        modules = module_payload()
        keys = {module['key'] for module in modules}
        self.assertIn('camera', keys)
        self.assertIn('printer', keys)
        self.assertIn('ai_engine', keys)
        self.assertIn('gallery', keys)
        self.assertIn('event_storage', keys)

    def test_asset_library_has_event_template_categories(self):
        templates = AssetLibraryService().templates()
        categories = {template.category for template in templates}
        self.assertIn('Wedding', categories)
        self.assertIn('Baptism', categories)
        self.assertIn('Birthday', categories)
        self.assertIn('Corporate', categories)

    def test_template_designer_plan_targets_final_outputs(self):
        plan = AssetLibraryService().template_designer_plan()
        self.assertIn('eventTitle', plan['editableFields'])
        self.assertIn('Wedding', plan['supportedCategories'])
        self.assertIn('final bordered/composited outputs', plan['guestDeliveryRule'])

    def test_photo_storage_plan_preserves_originals(self):
        plan = PhotoStorageService().storage_plan()
        self.assertIn('captures/original', plan.event_folders)
        self.assertIn('gallery/final', plan.event_folders)
        self.assertIn('raw originals remain operator-only', plan.original_preservation_rule)

    def test_gallery_qr_plan_targets_final_outputs(self):
        plan = GalleryService().qr_delivery_plan()
        self.assertEqual(plan['guestQrTarget'], 'final_bordered_session_gallery')
        self.assertIn('captures/original', plan['operatorOnlyFiles'])

    def test_session_gallery_exposes_final_outputs_only(self):
        plan = GalleryService().session_gallery_plan('session-test')
        self.assertEqual(plan['sessionId'], 'session-test')
        self.assertIn('final_guest_output', {item['kind'] for item in plan['guestVisibleFiles']})
        self.assertIn('captures/original', plan['operatorOnlyFolders'])
        self.assertIn('Raw/original Canon captures remain operator-only', plan['deliveryRule'])

    def test_session_review_plan_is_documented_in_routes(self):
        # Route payload is validated through the public route source because the v0.20
        # server uses only standard-library request handling.
        from pathlib import Path

        routes_source = Path(__file__).resolve().parents[1] / 'mybooth_server' / 'routes.py'
        text = routes_source.read_text(encoding='utf-8')
        self.assertIn('/booth/session-review-plan', text)
        self.assertIn('retake_last_photo', text)
        self.assertIn('select_print_quantity', text)
        self.assertIn('final bordered/composited guest gallery', text)


if __name__ == '__main__':
    unittest.main()
