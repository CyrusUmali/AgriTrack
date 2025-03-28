import 'package:flareline/pages/test/map_widget/map_panel/map_color_picker.dart';
import 'package:flareline/pages/test/map_widget/map_panel/map_panel_row.dart';
import 'package:flareline/pages/test/map_widget/map_panel/map_poly_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:latlong2/latlong.dart';
import 'pin_style.dart'; // Import the shared file
import 'package:flareline/pages/test/map_widget/polygon_manager.dart';

class PolygonInfoPanel extends StatefulWidget {
  final PolygonData polygon;
  final Function(LatLng) onUpdateCenter;
  final Function(PinStyle) onUpdatePinStyle;
  final Function(Color) onUpdateColor;
  final Function() onSave;

  const PolygonInfoPanel({
    Key? key,
    required this.polygon,
    required this.onUpdateCenter,
    required this.onUpdatePinStyle,
    required this.onUpdateColor,
    required this.onSave,
  }) : super(key: key);

  @override
  _PolygonInfoPanelState createState() => _PolygonInfoPanelState();
}

class _PolygonInfoPanelState extends State<PolygonInfoPanel> {
  late TextEditingController latController;
  late TextEditingController lngController;
  PinStyle selectedPinStyle = PinStyle.rice;
  Color selectedColor = Colors.blue;

  // Sample data for fish cage info
  String farmOwner = "Juan Dela Cruz";
  double areaHa = 15.5; // in hectares
  double yield = 5.5; // fish per square meter
  double averageKgValuePHP = 200.0; // average kg price in PHP
  String products = "Tilapia";
  String yearlyFilter = "2018"; // Default year

  @override
  void initState() {
    super.initState();
    latController =
        TextEditingController(text: widget.polygon.center.latitude.toString());
    lngController =
        TextEditingController(text: widget.polygon.center.longitude.toString());
    selectedColor = widget.polygon.color;
  }

  @override
  void dispose() {
    latController.dispose();
    lngController.dispose();
    super.dispose();
  }

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: selectedColor,
              onColorChanged: (color) {
                setState(() {
                  selectedColor = color;
                });
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                widget.onUpdateColor(selectedColor);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      constraints:
          BoxConstraints(maxHeight: 400), // Limit the height of the panel
      child: SingleChildScrollView(
        // Make the panel scrollable
        child: Column(
          children: [
            // Placeholder images section
            Container(
              height: 100, // Set a fixed height for the images section
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3, // Number of placeholder images
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey[300], // Placeholder background color
                        child: Icon(
                          Icons.image, // Placeholder icon
                          color: Colors.grey[600],
                          size: 40,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16), // Spacing between images and content
            ExpansionTile(
              title: Text(
                "Farm Name: ${widget.polygon.name}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              children: [
                PolygonDetailsSection(
                  farmOwner: farmOwner,
                  areaHa: areaHa,
                  yield: yield,
                  products: products,
                  yearlyFilter: yearlyFilter,
                  averageKgValuePHP: averageKgValuePHP,
                  onYearChanged: (newYear) {
                    setState(() {
                      yearlyFilter = newYear;
                    });
                  },
                ),
                if (widget.polygon.description != null)
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      "Description: ${widget.polygon.description}",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),

                LocationCoordinatesSection(
                  latController: latController,
                  lngController: lngController,
                ),

                // Add the PolygonVerticesSection here
                PolygonVerticesSection(vertices: widget.polygon.vertices),
                PinStyleDropdown(
                  selectedPinStyle: selectedPinStyle,
                  onPinStyleChanged: (newPinStyle) {
                    setState(() {
                      selectedPinStyle = newPinStyle;
                      widget.onUpdatePinStyle(selectedPinStyle);
                    });
                  },
                ),

                ColorPickerButton(
                  selectedColor: selectedColor,
                  onColorPicked: _showColorPicker,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    widget.onSave();
                  },
                  child: Text("Save Changes"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
