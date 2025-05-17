import 'package:ecommerce_app/common/widgets/app_bar/appbar.dart';
import 'package:ecommerce_app/features/personalization/controllers/address_controller.dart';
import 'package:ecommerce_app/utils/constants/sizes.dart';
import 'package:ecommerce_app/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class AddNewAdressScreen extends StatelessWidget {
  const AddNewAdressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AddressController.instance;

    return Scaffold(
      appBar: TAppBar(showBackArrow: true, title: Text('Add new Address')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Form(
            key: controller.addressFormKey,
            child: Column(
              children: [
                // Name
                TextFormField(
                  controller: controller.name,
                  validator:
                      (value) => TValidator.validateEmptyText('Name', value),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Iconsax.user),
                    labelText: 'Name',
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),

                TextFormField(
                  controller: controller.phoneNumber,
                  validator: TValidator.validatePhoneNumber,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Iconsax.mobile),
                    labelText: 'Phone Number',
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),

                // Street & Postal Code
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        validator:
                            (value) =>
                                TValidator.validateEmptyText('Street', value),
                        controller: controller.street,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Iconsax.building_31),
                          labelText: 'Street',
                        ),
                      ),
                    ),
                    const SizedBox(width: TSizes.spaceBtwInputFields),

                    // Expanded(
                    //   child: TextFormField(
                    //     decoration: InputDecoration(
                    //       prefixIcon: Icon(Iconsax.code),
                    //       labelText: 'Code',
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),

                // City & State
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controller.city,
                        validator:
                            (value) =>
                                TValidator.validateEmptyText('City', value),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Iconsax.building),
                          labelText: 'City',
                        ),
                      ),
                    ),
                    const SizedBox(width: TSizes.spaceBtwInputFields),

                    Expanded(
                      child: TextFormField(
                        controller: controller.state,
                        validator:
                            (value) =>
                                TValidator.validateEmptyText('State', value),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Iconsax.activity),
                          labelText: 'State',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),

                // Country
                TextFormField(
                  controller: controller.country,
                  validator:
                      (value) => TValidator.validateEmptyText('Country', value),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Iconsax.global),
                    labelText: 'Country',
                  ),
                ),
                const SizedBox(height: TSizes.defaultSpace),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.addNewAddresses,
                    child: Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
