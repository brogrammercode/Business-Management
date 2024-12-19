import 'package:flutter/material.dart';

class OrganisationDetail extends StatefulWidget {
  const OrganisationDetail({super.key});

  @override
  State<OrganisationDetail> createState() => _OrganisationDetailState();
}

class _OrganisationDetailState extends State<OrganisationDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sonu's Org",
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
