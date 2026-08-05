#!/usr/bin/env node

import fs from 'node:fs';
import path from 'node:path';

const [inputPath, outputPath] = process.argv.slice(2);
if (!inputPath || !outputPath) {
  throw new Error('Usage: node tools/generate_api_catalog.mjs <openapi.json> <catalog.dart>');
}

const spec = JSON.parse(fs.readFileSync(inputPath, 'utf8'));
const methods = new Set(['get', 'post', 'put', 'patch', 'delete', 'head', 'options']);
const surfaces = [
  'ads', 'app', 'auth', 'blogs', 'cart', 'cms', 'dev', 'discounts', 'events',
  'health', 'hobbies', 'legal', 'localization', 'media', 'metrics',
  'notifications', 'payments', 'privacy', 'products', 'profile', 'refunds',
  'share', 'subscriptions', 'support', 'tickets', 'translation', 'web3',
];

function dart(value) {
  return JSON.stringify(value).replaceAll('$', '\\$');
}

function surfaceFor(route) {
  const segment = route.split('/').filter(Boolean);
  if (segment[0] === 'admin') {
    return ({ads: 'ads', blogs: 'blogs', events: 'events', nfts: 'web3', support: 'support', users: 'profile'})[segment[1]] || 'app';
  }
  return ({
    ads: 'ads', app: 'app', auth: 'auth', blogs: 'blogs', cart: 'cart',
    cms: 'cms', dev: 'dev', discounts: 'discounts', events: 'events',
    health: 'health', hobbies: 'hobbies', legal: 'legal', localization: 'localization',
    media: 'media', metrics: 'metrics', nfts: 'web3', notifications: 'notifications',
    payments: 'payments', privacy: 'privacy', products: 'products', refunds: 'refunds',
    share: 'share', subscriptions: 'subscriptions', support: 'support', tickets: 'tickets',
    translation: 'translation', upload: 'media', users: 'profile', chat: 'events',
  })[segment[0]] || 'app';
}

const operations = [];
for (const [rawPath, pathItem] of Object.entries(spec.paths || {})) {
  for (const [rawMethod, operation] of Object.entries(pathItem)) {
    if (!methods.has(rawMethod) || !operation || typeof operation !== 'object') continue;
    const route = rawPath.replace(/^\/api\/v1(?=\/|$)/, '');
    const parameterSources = [...(pathItem.parameters || []), ...(operation.parameters || [])];
    const pathParameters = parameterSources
      .filter((parameter) => parameter.in === 'path')
      .map((parameter) => parameter.name);
    operations.push({
      operationId: operation.operationId || `${rawMethod}_${route.replace(/[^a-zA-Z0-9]+/g, '_')}`,
      method: rawMethod,
      path: route,
      surface: surfaceFor(route),
      tags: operation.tags || [],
      pathParameters,
      requiresAuth: Array.isArray(operation.security)
        ? operation.security.length > 0
        : Array.isArray(spec.security) && spec.security.length > 0,
      summary: operation.summary || null,
    });
  }
}

operations.sort((a, b) => `${a.path}:${a.method}`.localeCompare(`${b.path}:${b.method}`));
const count = operations.length;
const lines = [];
lines.push('// GENERATED FILE. DO NOT EDIT BY HAND.');
lines.push('// Source: OpenAPI snapshot supplied to tools/generate_api_catalog.mjs.');
lines.push('');
lines.push('enum GeneratedApiMethod { get, post, put, patch, delete, head, options }');
lines.push('');
lines.push(`enum GeneratedApiSurface { ${surfaces.join(', ')} }`);
lines.push('');
lines.push('class GeneratedApiDescriptor {');
lines.push('  const GeneratedApiDescriptor({');
lines.push('    required this.operationId, required this.method, required this.path,');
lines.push('    required this.surface, required this.tags, required this.pathParameters,');
lines.push('    required this.requiresAuth, this.summary,');
lines.push('  });');
lines.push('  final String operationId;');
lines.push('  final GeneratedApiMethod method;');
lines.push('  final String path;');
lines.push('  final GeneratedApiSurface surface;');
lines.push('  final List<String> tags;');
lines.push('  final List<String> pathParameters;');
lines.push('  final bool requiresAuth;');
lines.push('  final String? summary;');
lines.push("  String get routeKey => '\${method.name.toUpperCase()} \$path';");
lines.push('}');
lines.push('');
lines.push('class GeneratedApiCatalog {');
lines.push(`  static const int contractOperationCount = ${count};`);
lines.push('  static const List<GeneratedApiDescriptor> all = [');
for (const operation of operations) {
  lines.push('    GeneratedApiDescriptor(');
  lines.push(`      operationId: ${dart(operation.operationId)},`);
  lines.push(`      method: GeneratedApiMethod.${operation.method},`);
  lines.push(`      path: ${dart(operation.path)},`);
  lines.push(`      surface: GeneratedApiSurface.${operation.surface},`);
  lines.push(`      tags: [${operation.tags.map(dart).join(', ')}],`);
  lines.push(`      pathParameters: [${operation.pathParameters.map(dart).join(', ')}],`);
  lines.push(`      requiresAuth: ${operation.requiresAuth},`);
  if (operation.summary) lines.push(`      summary: ${dart(operation.summary)},`);
  lines.push('    ),');
}
lines.push('  ];');
lines.push('');
lines.push('  static final Map<GeneratedApiSurface, List<GeneratedApiDescriptor>> bySurface = {');
for (const surface of surfaces) {
  lines.push(`    GeneratedApiSurface.${surface}: all.where((item) => item.surface == GeneratedApiSurface.${surface}).toList(growable: false),`);
}
lines.push('  };');
lines.push('}');
lines.push('');

fs.mkdirSync(path.dirname(outputPath), {recursive: true});
fs.writeFileSync(outputPath, lines.join('\n'));
console.log(`Generated ${count} operations in ${outputPath}`);
