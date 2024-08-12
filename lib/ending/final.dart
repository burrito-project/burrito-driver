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
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Selecciona el Estado'),
                    content: DropdownButton<int>(
                      value: _selectedStatus,
                      items: _statusDescriptions.entries.map((entry) {
                        return DropdownMenuItem<int>(
                          value: entry.key,
                          child: Text(entry.value),
                        );
                      }).toList(),
                      onChanged: (int? newValue) {
                        setState(() {
                          _selectedStatus = newValue!;
                        });
                        widget.onStatusChanged(_selectedStatus);
                      },
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Aceptar'),
                        onPressed: () {
                          Navigator.of(context).pop(_selectedStatus);
                        },
                      ),
                      TextButton(
                        child: const Text('Cancelar'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              ).then((selectedStatus) {
                if (selectedStatus != null) {
                  setState(() {
                    _selectedStatus = selectedStatus;
                  });
                  widget.onStatusChanged(_selectedStatus);
                }
              });
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
