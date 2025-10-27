import 'package:flutter/material.dart';

class TimeData {
  final String challenge;
  final int time;

  TimeData(this.challenge, this.time);
}

class TimeChart extends StatelessWidget {
  const TimeChart({super.key});

  static final List<TimeData> timeData = [
    TimeData('Reto 1', 45),
    TimeData('Reto 2', 32),
    TimeData('Reto 3', 51),
    TimeData('Reto 4', 28),
    TimeData('Reto 5', 39),
    TimeData('Últimos 5', 35),
  ];

  @override
  Widget build(BuildContext context) {
    final maxTime = timeData.map((e) => e.time).reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 250,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 40,
          right: 20,
          top: 20,
          bottom: 10,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Y-axis labels
            SizedBox(
              width: 40,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${maxTime}s',
                    style: const TextStyle(
                      color: Color(0xFFD1D5DB),
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '${(maxTime * 0.66).round()}s',
                    style: const TextStyle(
                      color: Color(0xFFD1D5DB),
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '${(maxTime * 0.33).round()}s',
                    style: const TextStyle(
                      color: Color(0xFFD1D5DB),
                      fontSize: 12,
                    ),
                  ),
                  const Text(
                    '0s',
                    style: TextStyle(color: Color(0xFFD1D5DB), fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Bars
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: timeData.map((data) {
                        final heightPercent = data.time / maxTime;
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Tooltip(
                              message: '${data.challenge}: ${data.time}s',
                              child: FractionallySizedBox(
                                heightFactor: heightPercent,
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color(0xCCA855F7),
                                        Color(0x997C3AED),
                                      ],
                                    ),
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(4),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // X-axis labels
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: timeData.map((data) {
                      return Expanded(
                        child: Text(
                          data.challenge,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFFD1D5DB),
                            fontSize: 10,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
