import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";

class UserInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("YOUR INFORMATION"),
      ),
      body: UserInfoForm(),
    );
  }
}

class UserInfoForm extends StatefulWidget {
  @override
  _UserInfoFormState createState() => _UserInfoFormState();
}

class _UserInfoFormState extends State<UserInfoForm> {
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  final List<String> _genders = ['Female', 'Male'];
  String? _gender;
  String? _asthma;
  String? _smoking;
  final List<String> _options = ['No', 'Yes'];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Load and set the saved values if they are not null
    setState(() {
      _ageController.text = prefs.getString('age') ?? '';
      _monthController.text = prefs.getString('time_year') ?? '';
      _locationController.text = prefs.getString('distance2city') ?? '';
      if (prefs.containsKey('gender')) {
        _gender = _genders[int.parse(prefs.getString('gender')!)];
      }
      if (prefs.containsKey('asthma')) {
        _asthma = _options[int.parse(prefs.getString('asthma')!)];
      }
      if (prefs.containsKey('smoking')) {
        _smoking =
            _options[int.parse(prefs.getString('smoking')!)]; // Default to No
      }
    });
  }

  Future<void> _saveData(String key, String? value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value ?? '');
  }

  Widget createRoundedDropDown(
    width,
    select,
    type,
    List<String> options,
    void Function(String?) onChanged,
  ) {
    return Container(
      width: width * .95,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color.fromRGBO(65, 58, 58, 1.0)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            borderRadius: BorderRadius.circular(10),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
            hint: Text(select),
            value: type,
            isDense: true,
            onChanged: onChanged,
            items: options.map((document) {
              return DropdownMenuItem<String>(
                value: document,
                child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(document,
                        style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromRGBO(65, 58, 58, 1.0)))),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Center(
        child: Padding(
            padding: const EdgeInsets.all(50),
            child: SingleChildScrollView(
              child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('Gender'),
                    createRoundedDropDown(
                      width,
                      "Select Gender",
                      _gender,
                      _genders,
                      (newValue) {
                        setState(() {
                          _gender = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _ageController,
                      decoration: InputDecoration(
                          labelText: 'age',
                          hintText: "24",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20))),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _monthController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Month",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _locationController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Distance to the city. (miles)",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('Do you have asthma?'),
                    createRoundedDropDown(
                      width,
                      "Do you have asthma?",
                      _asthma,
                      _options,
                      (newValue) {
                        setState(() {
                          _asthma = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text('Do you smoke?'),
                    createRoundedDropDown(
                      width,
                      "Do you smoke?",
                      _smoking,
                      _options,
                      (newValue) {
                        setState(() {
                          _smoking = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      child: const Text("save"),
                      onPressed: () {
                        _saveData(
                            'gender', _genders.indexOf(_gender!).toString());
                        _saveData(
                            'asthma', _options.indexOf(_asthma!).toString());
                        _saveData(
                            'smoking', _options.indexOf(_smoking!).toString());
                        _saveData('age', _ageController.text.trim());
                        _saveData(
                            'distance2city', _locationController.text.trim());
                        _saveData('time_year', _monthController.text.trim());
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'information was saved successfully')));
                      },
                    )
                  ]),
            )));
  }
}
