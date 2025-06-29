import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:teamshare/utils/formate_event_date_time.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:teamshare/models/calendar.dart';
import 'package:teamshare/pages/calendar/bloc/calendar_bloc.dart';

class EventView extends StatefulWidget {
  final TeamCalendar event;

  const EventView({super.key, required this.event});

  @override
  State<EventView> createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  GoogleMapController? _mapController;

  void _launchMaps() async {
    final address = widget.event.address;
    if (address != null && address.isNotEmpty) {
      final encodedAddress = Uri.encodeComponent(address);
      String url;
      if (Platform.isIOS) {
        url = 'http://maps.apple.com/?daddr=$encodedAddress&dirflg=d';
      } else {
        url =
            'https://www.google.com/maps/dir/?api=1&destination=$encodedAddress&travelmode=driving';
      }
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasAddress =
        widget.event.address != null && widget.event.address!.isNotEmpty;
    final LatLng? eventLatLng =
        widget.event.latitude != null && widget.event.longitude != null
            ? LatLng(widget.event.latitude!, widget.event.longitude!)
            : null;

    return BlocProvider<CalendarBloc>.value(
      value: GetIt.I<CalendarBloc>(),
      child: BlocListener<CalendarBloc, CalendarState>(
        listener: (context, state) {
          if (state is UserAcceptedEvent) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Accepted event')));
          }
          if (state is UserDeclinedEvent) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Declined event')));
          }
        },
        child: Scaffold(
          appBar: AppBar(title: const Text('Event Details')),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.event.title ?? 'No Title',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.calendar_month, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        formatEventDateTime(
                          widget.event.start,
                          widget.event.end,
                        ),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  if (hasAddress) ...[
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.event.address!,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.directions),
                          onPressed: _launchMaps,
                          tooltip: 'Get Directions',
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (eventLatLng != null)
                      SizedBox(
                        height: 150,
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: eventLatLng,
                            zoom: 15,
                          ),
                          markers: {
                            Marker(
                              markerId: const MarkerId('event_location'),
                              position: eventLatLng,
                            ),
                          },
                          onMapCreated:
                              (controller) => _mapController = controller,
                          myLocationButtonEnabled: false,
                          zoomControlsEnabled: false,
                        ),
                      ),
                    const SizedBox(height: 20),
                  ],
                  const SizedBox(height: 12),
                  Text(
                    widget.event.description ?? 'No Description',
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.grey.withOpacity(0.10),
                            foregroundColor: Colors.grey[700],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side: BorderSide(
                                color: Colors.grey[400]!,
                                width: 2,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () {
                            context.read<CalendarBloc>().add(
                              DeclineEvent(eventId: widget.event.id!),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 14,
                                backgroundColor: Colors.grey[400],
                                child: Text(
                                  (widget.event.declined?.length ?? 0)
                                      .toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Icon(Icons.close, color: Colors.grey[700]),
                              const SizedBox(width: 8),
                              const Text(
                                'Decline',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.green.withOpacity(0.10),
                            foregroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side: const BorderSide(
                                color: Colors.green,
                                width: 2,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () {
                            context.read<CalendarBloc>().add(
                              AcceptEvent(eventId: widget.event.id!),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 14,
                                backgroundColor: Colors.green,
                                child: Text(
                                  (widget.event.accepted?.length ?? 0)
                                      .toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Icon(Icons.check, color: Colors.green),
                              const SizedBox(width: 8),
                              const Text(
                                'Join',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (widget.event.attachments != null &&
                      widget.event.attachments!.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const Text(
                      'Attachments',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 90,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.event.attachments!.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final url = widget.event.attachments![index];
                          final isImage =
                              url.endsWith('.jpg') ||
                              url.endsWith('.jpeg') ||
                              url.endsWith('.png') ||
                              url.endsWith('.gif');
                          final isPdf = url.endsWith('.pdf');
                          return GestureDetector(
                            onTap: () {
                              launchUrl(Uri.parse(url));
                            },
                            child: Container(
                              width: 80,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[100],
                              ),
                              child:
                                  isImage
                                      ? ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          url,
                                          fit: BoxFit.cover,
                                          width: 80,
                                          height: 80,
                                          errorBuilder:
                                              (_, __, ___) => const Icon(
                                                Icons.broken_image,
                                                size: 40,
                                              ),
                                        ),
                                      )
                                      : Center(
                                        child:
                                            isPdf
                                                ? const Icon(
                                                  Icons.picture_as_pdf,
                                                  color: Colors.red,
                                                  size: 40,
                                                )
                                                : const Icon(
                                                  Icons.insert_drive_file,
                                                  color: Colors.blueGrey,
                                                  size: 40,
                                                ),
                                      ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
