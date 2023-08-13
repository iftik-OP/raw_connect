import 'package:flutter/material.dart';

class MeetingRoomBookingContainer extends StatelessWidget {
  final String roomName;
  final String date;
  final List<dynamic>
      availableTimeSlots; // List of booleans representing time slot availability.

  MeetingRoomBookingContainer({
    required this.roomName,
    required this.date,
    required this.availableTimeSlots,
  });

  var timings = ['9:00 AM', '9:30 AM', '10:00 AM', '10:30 AM', '11:00 AM',
    '11:30 AM', '12:00 PM', '12:30 PM', '1:00 PM', '1:30 PM', '2:00 PM',
    '2:30 PM', '3:00 PM', '3:30 PM', '4:00 PM', '4:30 PM', '5:00 PM',
    '5:30 PM', '6:00 PM', '6:30 PM', '7:00 PM', '7:30 PM', '8:00 PM',
    '8:30 PM', '9:00 PM', '9:30 PM', '10:00 PM', '10:30 PM', '11:00 PM',
    '11:30 PM', '12:00 AM', '12:30 AM', '1:00 AM', '1:30 AM', '2:00 AM',
    '2:30 AM', '3:00 AM', '3:30 AM', '4:00 AM', '4:30 AM', '5:00 AM',
    '5:30 AM', '6:00 AM', '6:30 AM', '7:00 AM', '7:30 AM', '8:00 AM',
    '8:30 AM', '9:00 AM', ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 8,
      ),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$roomName',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 18),
              SizedBox(width: 4),
              Text(
                'Date: $date',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Booked Time Slots:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 4),
          // Use ListView.builder to show available time slots.
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: availableTimeSlots.length,
            itemBuilder: (context, index) {
              // Check if the time slot is available (true) and show it.
              if (availableTimeSlots[index]) {
                final startTime = '${timings[index]}';
                final endTime = '${timings[index + 1]}';
                return Row(
                  children: [
                    Icon(Icons.access_time, size: 18),
                    SizedBox(width: 4),
                    Text(
                      'Time: $startTime - $endTime',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                );
              } else {
                return SizedBox
                    .shrink(); // Hide the time slot if it's not available.
              }
            },
          ),
        ],
      ),
    );
  }
}
