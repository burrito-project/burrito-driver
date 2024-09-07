import 'package:burrito_driver_app/features/status/data/entities/service_status.dart';
import 'package:flutter/material.dart';

class ChangeStatusButton extends StatefulWidget {
  final VoidCallback onStop;
  final BusServiceStatus currentStatus;
  final Function(BusServiceStatus newStatus) onStatusChanged;

  const ChangeStatusButton({
    super.key,
    required this.onStop,
    required this.currentStatus,
    required this.onStatusChanged,
  });

  @override
  ChangeStatusButtonState createState() => ChangeStatusButtonState();
}

class ChangeStatusButtonState extends State<ChangeStatusButton> {
  late BusServiceStatus _selectedStatus;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.currentStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () async {
              final RenderBox button = context.findRenderObject() as RenderBox;
              final Offset buttonOffset = button.localToGlobal(Offset.zero);
              final Size buttonSize = button.size;

              final selectedStatus = await showMenu<BusServiceStatus>(
                context: context,
                position: RelativeRect.fromLTRB(
                  buttonOffset.dx,
                  buttonOffset.dy - 200,
                  buttonOffset.dx + buttonSize.width,
                  buttonOffset.dy,
                ),
                items: BusServiceStatus.selectable().map((sts) {
                  return PopupMenuItem<BusServiceStatus>(
                    value: sts,
                    child: Text(sts.displayName),
                  );
                }).toList(),
              );

              if (selectedStatus != null) {
                setState(() {
                  _selectedStatus = selectedStatus;
                  widget.onStatusChanged(_selectedStatus);
                });
              }
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: _selectedStatus.locatable
                  ? Colors.green
                  : const Color(0xFF262F31),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 20,
              ),
            ),
            child: Text(
              _selectedStatus.displayName,
              style: const TextStyle(
                fontSize: 24,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).clearSnackBars();
            widget.onStop();
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: _selectedStatus.locatable
                ? Colors.red
                : const Color(0xFF262F31),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 20,
            ),
          ),
          child: const Icon(Icons.stop, size: 30),
        )
      ],
    );
  }
}
