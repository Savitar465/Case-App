import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// User-Agent sent with OpenStreetMap tile requests. OSM's tile usage policy
/// asks for a stable identifier; reuse this everywhere we render a map.
const String kMapUserAgent = 'com.vikus.market_app';

/// OpenStreetMap raster tile endpoint. Free and key-less — fine for MVP; swap
/// the template for a paid tile host if traffic grows.
const String kOsmTileUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

/// A non-interactive map with a single pin, used to show a saved business
/// location on read-only screens. Renders nothing when coordinates are unset
/// (stored as 0,0), so callers can drop it in unconditionally.
class StaticLocationMap extends StatelessWidget {
  const StaticLocationMap({
    super.key,
    required this.latitude,
    required this.longitude,
    this.height = 180,
    this.zoom = 15,
  });

  final double latitude;
  final double longitude;
  final double height;
  final double zoom;

  bool get _hasLocation => latitude != 0 || longitude != 0;

  @override
  Widget build(BuildContext context) {
    if (!_hasLocation) return const SizedBox.shrink();
    final point = LatLng(latitude, longitude);
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: FlutterMap(
          options: MapOptions(
            initialCenter: point,
            initialZoom: zoom,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.none,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: kOsmTileUrl,
              userAgentPackageName: kMapUserAgent,
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: point,
                  width: 44,
                  height: 44,
                  // topCenter anchors the pin's tip on the coordinate.
                  alignment: Alignment.topCenter,
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 44,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
