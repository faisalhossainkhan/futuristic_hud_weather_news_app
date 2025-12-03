import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../constants/app_constants.dart';

class StatusBar extends StatelessWidget {
  final int weatherTemp;
  final DateTime currentTime;
  final ColorTheme theme;

  const StatusBar({
    super.key,
    required this.weatherTemp,
    required this.currentTime,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final formattedTime = DateFormat('HH:mm:ss').format(currentTime);
    final formattedDate = DateFormat('MM/dd/yyyy').format(currentTime);

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: theme.primary.withValues(alpha:0.5)),
        color: theme.primary.withValues(alpha:0.05),
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: theme.primary.withValues(alpha:0.1),
            blurRadius: 5.0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text.rich(
              TextSpan(
                style: AppTheme.getHudTextStyle(
                  color: theme.alert,
                  fontSize: 13,
                ),
                children: [
                  const TextSpan(text: 'STATUS: ACTIVE | TEMP: '),
                  TextSpan(
                    text: '$weatherTemp°C',
                    style: AppTheme.getHudTextStyle(
                      color: theme.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          const SizedBox(width: 10),
          Text.rich(
            TextSpan(
              style: AppTheme.getHudTextStyle(
                color: theme.primary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              children: [
                TextSpan(text: '$formattedDate / '),
                TextSpan(text: formattedTime),
              ],
            ),
          ),
        ],
      ),
    );
  }
}