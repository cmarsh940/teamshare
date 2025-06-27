// import 'dart:io' show Platform;
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get_it/get_it.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:teamshare/models/calendar.dart';
// import 'package:teamshare/pages/calendar/bloc/calendar_bloc.dart';

// class EventView extends StatefulWidget {
//   final TeamCalendar event;

//   const EventView({super.key, required this.event});

//   @override
//   State<EventView> createState() => _EventViewState();
// }

// class _EventViewState extends State<EventView> {
//   GoogleMapController? _mapController;

//   void _launchMaps() async {
//     final address = widget.event.address;
//     if (address != null && address.isNotEmpty) {
//       final encodedAddress = Uri.encodeComponent(address);
//       String url;
//       if (Platform.isIOS) {
//         url = 'http://maps.apple.com/?daddr=$encodedAddress&dirflg=d';
//       } else {
//         url =
//             'https://www.google.com/maps/dir/?api=1&destination=$encodedAddress&travelmode=driving';
//       }
//       if (await canLaunchUrl(Uri.parse(url))) {
//         await launchUrl(Uri.parse(url));
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final hasAddress =
//         widget.event.address != null && widget.event.address!.isNotEmpty;
//     final LatLng? eventLatLng =
//         widget.event.latitude != null && widget.event.longitude != null
//             ? LatLng(widget.event.latitude!, widget.event.longitude!)
//             : null;

//     return BlocProvider<CalendarBloc>.value(
//       value: GetIt.I<CalendarBloc>(),
//       child: BlocListener<CalendarBloc, CalendarState>(
//         listener: (context, state) {
//           if (state is UserAcceptedEvent) {
//             ScaffoldMessenger.of(
//               context,
//             ).showSnackBar(const SnackBar(content: Text('Accepted event')));
//           }
//           if (state is UserDeclinedEvent) {
//             ScaffoldMessenger.of(
//               context,
//             ).showSnackBar(const SnackBar(content: Text('Declined event')));
//           }
//         },
//         child: Scaffold(
//           appBar: AppBar(title: const Text('Event Details')),
//           body: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     widget.event.title ?? 'No Title',
//                     style: const TextStyle(
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   Text(
//                     widget.event.description ?? 'No Description',
//                     style: const TextStyle(fontSize: 18, color: Colors.grey),
//                   ),
//                   const SizedBox(height: 20),
//                   Row(
//                     children: [
//                       const Icon(Icons.calendar_today, size: 20),
//                       const SizedBox(width: 8),
//                       Text(
//                         'Start: ${widget.event.start?.toLocal().toString() ?? 'No Start Date'}',
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       const Icon(Icons.calendar_month, size: 20),
//                       const SizedBox(width: 8),
//                       Text(
//                         'End: ${widget.event.end?.toLocal().toString() ?? 'No End Date'}',
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   if (hasAddress) ...[
//                     Row(
//                       children: [
//                         const Icon(Icons.location_on, color: Colors.red),
//                         const SizedBox(width: 8),
//                         Expanded(
//                           child: Text(
//                             widget.event.address!,
//                             style: const TextStyle(fontSize: 16),
//                           ),
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.directions),
//                           onPressed: _launchMaps,
//                           tooltip: 'Get Directions',
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 12),
//                     if (eventLatLng != null)
//                       SizedBox(
//                         height: 200,
//                         child: GoogleMap(
//                           initialCameraPosition: CameraPosition(
//                             target: eventLatLng,
//                             zoom: 15,
//                           ),
//                           markers: {
//                             Marker(
//                               markerId: const MarkerId('event_location'),
//                               position: eventLatLng,
//                             ),
//                           },
//                           onMapCreated:
//                               (controller) => _mapController = controller,
//                           myLocationButtonEnabled: false,
//                           zoomControlsEnabled: false,
//                         ),
//                       ),
//                     const SizedBox(height: 20),
//                   ],
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       ElevatedButton.icon(
//                         icon: const Icon(Icons.check),
//                         label: const Text('Going'),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.green,
//                         ),
//                         onPressed: () {
//                           context.read<CalendarBloc>().add(
//                             AcceptEvent(eventId: widget.event.id!),
//                           );
//                         },
//                       ),
//                       ElevatedButton.icon(
//                         icon: const Icon(Icons.close),
//                         label: const Text('Decline'),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.red,
//                         ),
//                         onPressed: () {
//                           context.read<CalendarBloc>().add(
//                             DeclineEvent(eventId: widget.event.id!),
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
