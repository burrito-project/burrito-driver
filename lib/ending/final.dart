import 'package:flutter/material.dart';

class StatusButton extends StatefulWidget {
  final VoidCallback onStop;
  final int currentStatus;
  final Function(int) onStatusChanged;

  const StatusButton({
    super.key,
    required this.onStop,
    required this.currentStatus,
    required this.onStatusChanged,
  });

  @override
  StatusButtonState createState() => StatusButtonState();
}

class StatusButtonState extends State<StatusButton> {
  late int _selectedStatus;

  // Mapa de estados con sus descripciones
  final Map<int, String> _statusDescriptions = {
    0: 'En ruta',
    1: 'Fuera de servicio',
    2: 'En descanso',
    3: 'Accidente',
  };

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

              final selectedStatus = await showMenu<int>(
                context: context,
                position: RelativeRect.fromLTRB(
                  buttonOffset.dx,
                  buttonOffset.dy - 200,
                  buttonOffset.dx + buttonSize.width,
                  buttonOffset.dy,
                ),
                items: _statusDescriptions.entries.map((entry) {
                  return PopupMenuItem<int>(
                    value: entry.key,
                    child: Text(entry.value),
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
              backgroundColor: const Color(0xFF262F31),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 20,
              ),
            ),
            child: Text(
              _statusDescriptions[_selectedStatus] ?? 'Estado Desconocido',
              style: const TextStyle(
                fontSize: 24,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: () {
            widget.onStop();
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFF262F31),
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
