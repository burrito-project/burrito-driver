import 'package:flutter/material.dart';

class StatusButton extends StatefulWidget {
  final VoidCallback onStop;
  final int currentStatus;
  final Function(int)
      onStatusChanged; // Función para manejar el cambio de estado

  const StatusButton({
    super.key,
    required this.onStop,
    required this.currentStatus,
    required this.onStatusChanged, // Acepta la función como parámetro
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
    // Get screen size
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/img/real_burrito_icon.png',
                  width: screenWidth * 0.8,
                  height: screenWidth * 0.8,
                ),
                SizedBox(height: screenHeight * 0.1),
              ],
            ),
            Center(
              child: Row(
                children: [
                  Flexible(
                    child: SizedBox(
                      width: screenWidth * 0.75,
                      height: screenHeight * 0.08,
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Selecciona el Estado'),
                                content: DropdownButton<int>(
                                  value: _selectedStatus,
                                  items:
                                      _statusDescriptions.entries.map((entry) {
                                    return DropdownMenuItem<int>(
                                      value: entry.key,
                                      child: Text(entry.value),
                                    );
                                  }).toList(),
                                  onChanged: (int? newValue) {
                                    setState(() {
                                      _selectedStatus = newValue!;
                                    });
                                    widget.onStatusChanged(
                                        _selectedStatus); // Llama a la función pasada
                                  },
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Aceptar'),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(_selectedStatus);
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
                              widget.onStatusChanged(
                                  _selectedStatus); // Llama a la función pasada
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor:
                              const Color.fromARGB(255, 37, 37, 37),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          _statusDescriptions[_selectedStatus] ??
                              'Estado Desconocido',
                          style: TextStyle(fontSize: screenHeight * 0.025),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.015),
                  SizedBox(
                    width: screenWidth * 0.15,
                    height: screenHeight * 0.08,
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onStop();
                        Navigator.pop(context, _selectedStatus);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color.fromARGB(255, 37, 37, 37),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Icon(Icons.stop, size: screenWidth * 0.09),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
          ],
        ),
      ),
    );
  }
}
