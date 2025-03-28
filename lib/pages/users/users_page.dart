import 'package:flareline/pages/users/add_user_modal.dart'; // Import the DeleteFarmerModal
import 'package:flutter/material.dart';
import 'package:flareline/pages/users/grid_card.dart';
import 'package:flareline/pages/layout.dart';
import 'package:flareline/pages/users/users.dart';
import 'package:flareline/pages/sectors/year_filter_dropdown.dart'; // Import the new widget

class UsersPage extends LayoutWidget {
  const UsersPage({super.key});

  @override
  String breakTabTitle(BuildContext context) {
    return 'Users';
  }

  @override
  Widget contentDesktopWidget(BuildContext context) {
    // State to hold the selected year
    int selectedYear = DateTime.now().year;

    return Column(
      children: [
        // Year Filter Dropdown
        Align(
          alignment: Alignment.centerRight, // Aligns the content to the right
          child: Row(
            mainAxisSize: MainAxisSize
                .min, // Ensures the Row takes only the space it needs
            children: [
              // Add Farmer Button on the left
              ElevatedButton(
                onPressed: () {
                  // Example data for the farmer
                  String farmerName = "John Doe";
                  String farmerId = "123";

                  AddUserModal.show(
                    context: context,
                    onUserAdded: (String name, String email, String password,
                        String role) {
                      // Handle the new user data here
                      print('New User Added:');
                      print('Name: $name');
                      print('Email: $email');
                      print('Password: $password');
                      print('Role: $role');

                      // You can call your ViewModel or API here to save the user
                    },
                  );
                },
                child: const Text("Add User"),
              ),
              const SizedBox(
                  width: 16), // Add spacing between the button and the dropdown
              // Year Filter Dropdown
              YearFilterDropdown(
                selectedYear: selectedYear,
                onYearChanged: (int? newValue) {
                  if (newValue != null) {
                    // Update the selected year
                    selectedYear = newValue;
                    // You can add logic here to refresh the data based on the selected year
                    print("Selected Year: $selectedYear");
                  }
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const SectorsGridCard(),
        const SizedBox(height: 16),
        const Users(),
        const SizedBox(height: 16),
      ],
    );
  }
}
