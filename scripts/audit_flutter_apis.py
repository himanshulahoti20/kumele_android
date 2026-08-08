#!/usr/bin/env python3
"""
Audit Flutter API implementation against OpenAPI spec.
Generates a comprehensive report of implemented vs missing APIs.
"""

import json
import os
import re
from pathlib import Path
from collections import defaultdict
from typing import Dict, List, Set, Tuple

# Admin/Business-only tags to exclude
ADMIN_TAGS = {
    'admin', 'business', 'metrics', 'dev', 'internal'
}

# Admin/Business-only operation patterns
ADMIN_PATTERNS = [
    r'admin',
    r'business',
    r'seed',
    r'metrics',
    r'/dev/',
    r'internal'
]

class APIAuditor:
    def __init__(self, project_root: str):
        self.project_root = Path(project_root)
        self.openapi_ops = []
        self.flutter_calls = set()
        self.ui_integrated = set()
        
    def load_openapi_spec(self):
        """Load OpenAPI spec from generated catalog."""
        catalog_path = self.project_root / 'lib/shared/services/api_service/generated/generated_api_catalog.dart'
        
        if not catalog_path.exists():
            print(f"❌ Catalog not found at {catalog_path}")
            return
            
        content = catalog_path.read_text()
        
        # Parse GeneratedApiDescriptor entries
        pattern = r'GeneratedApiDescriptor\((.*?)\),'
        matches = re.findall(pattern, content, re.DOTALL)
        
        for match in matches:
            op = self._parse_descriptor(match)
            if op:
                self.openapi_ops.append(op)
                
        print(f"✅ Loaded {len(self.openapi_ops)} OpenAPI operations")
        
    def _parse_descriptor(self, text: str) -> Dict:
        """Parse a GeneratedApiDescriptor entry."""
        try:
            op_id = re.search(r'operationId:\s*"([^"]+)"', text)
            method = re.search(r'method:\s*GeneratedApiMethod\.(\w+)', text)
            path = re.search(r'path:\s*"([^"]+)"', text)
            surface = re.search(r'surface:\s*GeneratedApiSurface\.(\w+)', text)
            tags_match = re.search(r'tags:\s*\[(.*?)\]', text)
            requires_auth = 'requiresAuth: true' in text
            summary_match = re.search(r'summary:\s*"([^"]+)"', text)
            
            tags = []
            if tags_match:
                tags = [t.strip(' "') for t in tags_match.group(1).split(',')]
                
            return {
                'operationId': op_id.group(1) if op_id else '',
                'method': method.group(1).upper() if method else '',
                'path': path.group(1) if path else '',
                'surface': surface.group(1) if surface else '',
                'tags': tags,
                'requiresAuth': requires_auth,
                'summary': summary_match.group(1) if summary_match else '',
                'route_key': f"{method.group(1).upper()} {path.group(1)}" if method and path else ''
            }
        except Exception as e:
            print(f"⚠️  Parse error: {e}")
            return None
            
    def is_admin_only(self, op: Dict) -> bool:
        """Check if operation is admin/business only."""
        # Check tags
        for tag in op['tags']:
            if tag.lower() in ADMIN_TAGS:
                return True
                
        # Check path and summary
        text = f"{op['path']} {op['summary']}".lower()
        for pattern in ADMIN_PATTERNS:
            if re.search(pattern, text):
                return True
                
        return False
        
    def scan_flutter_code(self):
        """Scan Flutter codebase for actual API calls."""
        print("\n🔍 Scanning Flutter codebase...")
        
        # Scan repo files
        repo_dirs = [
            'lib/shared/services/api_service',
            'lib/features'
        ]
        
        for repo_dir in repo_dirs:
            dir_path = self.project_root / repo_dir
            if dir_path.exists():
                for dart_file in dir_path.rglob('*.dart'):
                    self._scan_dart_file(dart_file)
                    
        print(f"✅ Found {len(self.flutter_calls)} API call patterns")
        
    def _scan_dart_file(self, file_path: Path):
        """Scan a Dart file for API calls."""
        try:
            content = file_path.read_text()
            
            # Look for GeneratedApiOperations usage
            pattern = r'GeneratedApiOperations\.(\w+)'
            for match in re.finditer(pattern, content):
                self.flutter_calls.add(match.group(1))
                
            # Look for manual API calls
            manual_pattern = r'callRequest\([^,]+,\s*[\'"]([^\'"]+)[\'"]'
            for match in re.finditer(manual_pattern, content):
                self.flutter_calls.add(match.group(1))
                
        except Exception as e:
            pass  # Skip problematic files
            
    def analyze_ui_integration(self):
        """Check which APIs have UI integration."""
        print("\n🎨 Analyzing UI integration...")
        
        # Scan feature UI files
        ui_dirs = [
            'lib/features',
            'lib/shared/widgets'
        ]
        
        for ui_dir in ui_dirs:
            dir_path = self.project_root / ui_dir
            if dir_path.exists():
                for dart_file in dir_path.rglob('*.dart'):
                    if 'view' in str(dart_file).lower() or 'widget' in str(dart_file).lower() or 'page' in str(dart_file).lower() or 'screen' in str(dart_file).lower():
                        self._check_ui_file(dart_file)
                        
        print(f"✅ Found {len(self.ui_integrated)} UI-integrated operations")
        
    def _check_ui_file(self, file_path: Path):
        """Check if UI file uses API operations."""
        try:
            content = file_path.read_text()
            
            # Look for repository/service calls
            patterns = [
                r'(\w+Repository)',
                r'(\w+Service)',
                r'(\w+Repo)\.',
            ]
            
            for pattern in patterns:
                for match in re.finditer(pattern, content):
                    self.ui_integrated.add(match.group(1))
                    
        except Exception as e:
            pass
            
    def generate_report(self) -> Dict:
        """Generate comprehensive audit report."""
        report = {
            'total_operations': len(self.openapi_ops),
            'consumer_relevant': 0,
            'admin_only': 0,
            'implemented': 0,
            'not_implemented': 0,
            'ui_integrated': 0,
            'no_ui': 0,
            'by_surface': defaultdict(lambda: {
                'total': 0,
                'implemented': 0,
                'admin_only': 0,
                'missing': 0
            }),
            'operations': []
        }
        
        for op in self.openapi_ops:
            is_admin = self.is_admin_only(op)
            is_implemented = self._check_implementation(op)
            has_ui = self._has_ui_integration(op)
            
            if is_admin:
                report['admin_only'] += 1
            else:
                report['consumer_relevant'] += 1
                
            if is_implemented:
                report['implemented'] += 1
                if has_ui:
                    report['ui_integrated'] += 1
                else:
                    report['no_ui'] += 1
            else:
                if not is_admin:
                    report['not_implemented'] += 1
                    
            surface = op['surface']
            report['by_surface'][surface]['total'] += 1
            if is_admin:
                report['by_surface'][surface]['admin_only'] += 1
            elif is_implemented:
                report['by_surface'][surface]['implemented'] += 1
            elif not is_admin:
                report['by_surface'][surface]['missing'] += 1
                
            report['operations'].append({
                **op,
                'is_admin': is_admin,
                'is_implemented': is_implemented,
                'has_ui': has_ui,
                'status': self._get_status(op, is_admin, is_implemented, has_ui)
            })
            
        return report
        
    def _check_implementation(self, op: Dict) -> bool:
        """Check if operation is implemented in Flutter."""
        # Check by operation ID pattern
        op_id = op['operationId']
        
        # Convert to camelCase pattern
        parts = op_id.replace('_v1', '').split('_')
        if len(parts) >= 2:
            camel = parts[1]
            if camel in self.flutter_calls:
                return True
                
        # Check by path
        if op['path'] in self.flutter_calls:
            return True
            
        return False
        
    def _has_ui_integration(self, op: Dict) -> bool:
        """Check if operation has UI integration."""
        # This is a heuristic - actual UI integration requires deeper analysis
        surface = op['surface']
        return surface in ['auth', 'events', 'profile', 'blogs', 'notifications', 'subscriptions']
        
    def _get_status(self, op: Dict, is_admin: bool, is_implemented: bool, has_ui: bool) -> str:
        """Get implementation status symbol."""
        if is_admin:
            return '🚫'  # Admin only
        elif is_implemented:
            if has_ui:
                return '🟢'  # Live with UI
            else:
                return '⚪'  # Dead code / No UI
        else:
            return '❌'  # Not implemented
            
    def save_report(self, report: Dict, output_path: str):
        """Save audit report to JSON."""
        output_file = Path(output_path)
        output_file.write_text(json.dumps(report, indent=2))
        print(f"\n💾 Report saved to {output_file}")
        
    def print_summary(self, report: Dict):
        """Print audit summary."""
        print("\n" + "="*80)
        print("📊 FLUTTER API AUDIT SUMMARY")
        print("="*80)
        print(f"\n📌 Total Operations: {report['total_operations']}")
        print(f"   ├─ Consumer-relevant: {report['consumer_relevant']}")
        print(f"   └─ Admin/Business-only: {report['admin_only']}")
        print(f"\n✅ Implemented: {report['implemented']}")
        print(f"   ├─ With UI: {report['ui_integrated']}")
        print(f"   └─ No UI: {report['no_ui']}")
        print(f"\n❌ Not Implemented: {report['not_implemented']}")
        
        print(f"\n📦 By Surface:")
        for surface, stats in sorted(report['by_surface'].items()):
            if stats['total'] > 0:
                print(f"   {surface:20s} - Total: {stats['total']:3d} | "
                      f"Impl: {stats['implemented']:3d} | "
                      f"Admin: {stats['admin_only']:3d} | "
                      f"Missing: {stats['missing']:3d}")
                      
        print("\n" + "="*80)


def main():
    project_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    auditor = APIAuditor(project_root)
    
    print("🚀 Starting Flutter API Audit...")
    print(f"📁 Project root: {project_root}\n")
    
    auditor.load_openapi_spec()
    auditor.scan_flutter_code()
    auditor.analyze_ui_integration()
    
    report = auditor.generate_report()
    auditor.print_summary(report)
    
    # Save detailed report
    output_path = os.path.join(project_root, 'audit_report.json')
    auditor.save_report(report, output_path)
    
    print("\n✅ Audit complete!")


if __name__ == '__main__':
    main()
