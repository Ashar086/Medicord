import 'package:brainmri/models/conclusion_model.dart';
import 'package:brainmri/models/observation_mode.dart';
import 'package:brainmri/screens/observation/brain/brain_observation_model.dart';
import 'package:brainmri/screens/observation/components/custom_dropdown.dart';
import 'package:brainmri/screens/observation/components/template.dart';
import 'package:brainmri/screens/user/user_reducer.dart';
import 'package:brainmri/store/app_logs.dart';
import 'package:brainmri/store/app_store.dart';
import 'package:brainmri/utils/refreshable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class BrainObservationForm extends StatefulWidget {
  const BrainObservationForm({Key? key}) : super(key: key);

  @override
  _BrainObservationFormState createState() => _BrainObservationFormState();
}

class _BrainObservationFormState extends State<BrainObservationForm> {
  final BrainObservationModel observation = BrainObservationModel();

  String radiologistName = '';

  void showDialoga() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Radiologist Name'),
          content: TextField(
            onChanged: (value) => setState(() => radiologistName = value),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: _submitForm,
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _submitForm() {

    print(observation.toJson());
    
    var state = StoreProvider.of<GlobalState>(context).state.appState.userState;

    final ObservationModel newOb = ObservationModel(
      conclusion: ConclusionModel(
        text: state.conclusion,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isValidated: true,
        isApproved: false,
      ),
      text: state.observationString,
      radiologistName: radiologistName,
      observedAt: DateTime.now(),
    );

    StoreProvider.of<GlobalState>(context).dispatch(
      SavePatientObservationAction(state.selectedPatient['id']! , newOb),
    );

    Navigator.of(context).pop();
  }

  void _generateConclusion() {
    print('generate conclusion');


    print('observation: ${observation.toJson()}');

    String observationString = fillObservationTemplate(observation);
    
    // Below template, for testing purposes only
    // ------------ //
//     String observationString = """
// - Scanning Technique: T1 FSE-sagittal, T2 FLAIR, T2 FSE-axial, T2 FSE-coronal
// - Basal Ganglia:
//   - Location: Usually located
//   - Symmetry: Symmetrical
//   - Contour: Clear, even contours
//   - Dimensions: Not changed
//   - MR Signal: Not changed
// - Brain Grooves and Ventricles:
//   - Lateral Ventricles Width: Right: 7 mm, Left: 9 mm
//   - Third Ventricle Width: 4 mm
//   - Sylvian Aqueduct: Not changed
//   - Fourth Ventricle: Tent-shaped and not dilated
// - Brain Structures:
//   - Corpus Callosum: Normal shape and size
//   - Brain Stem: Without features
//   - Cerebellum: Normal shape
//   - Craniovertebral Junction: Unchanged
//   - Pituitary Gland: Normal shape, height 4 mm in sagittal projection
// - Optic Nerves and Orbital Structures:
//   - Orbital Cones Shape: Unchanged
//   - Eyeballs Shape and Size: Spherical and normal size
//   - Optic Nerves Diameter: Preserved
//   - Extraocular Muscles: Normal size, without pathological signals
//   - Retrobulbar Fatty Tissue: Without pathological signals
// - Paranasal Sinuses:
//   - Cysts Presence: Not mentioned
//   - Cysts Size: Not mentioned
//   - Sinuses Pneumatization: Usually pneumatized
// - Additional Observations: None mentioned
// """;
// ------------ //

    print('observationString: $observationString');

    print('saving observation');

    StoreProvider.of<GlobalState>(context).dispatch(
      SaveObservationAction(observationString),
    );

    print('generating conclusion');
    
    StoreProvider.of<GlobalState>(context).dispatch(
      GenerateConclusionAction(observationString),
    );
  }

  List<String> errors = [];

  @override
  void initState() {
    super.initState();

    initErrors();
  }


  void addError({required String error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({required String error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  void initErrors() {
    setState(() {
      errors = [];
    });
  }

  String? name;
  DateTime? bDate;

  bool other = false;

      void reFetchData()  {
          print('refetching');
        store.dispatch(FetchAllPatientNamesAction());
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    reFetchData();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return 
    StoreConnector<GlobalState, UserState>(
      onInit: (store) {
        store.dispatch(FetchAllPatientNamesAction());
      },
      converter: (appState) => appState.state.appState.userState,
      builder: (context, userState) {
        return

    SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: 
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
                                if (userState.isSavingNewPatient)
                        const Column(
                          children: [
                            LinearProgressIndicator(),
                            Padding(padding: EdgeInsets.only(left:16.0, right:16.0),
                              child: 
                                Text('Saving new patient. Please wait...'),
                            ),
                          ],
                        ),
                                if (userState.isSavingObservation)
                        const Column(
                          children: [
                            LinearProgressIndicator(),
                            Padding(padding: EdgeInsets.only(left:16.0, right:16.0),
                              child: 
                                Text('Saving new observation. Please wait...'),
                            ),
                          ],
                        ),
                                if (userState.isGeneratingConclusion)
                        const Column(
                          children: [
                            LinearProgressIndicator(),
                            Padding(padding: EdgeInsets.only(left:16.0, right:16.0),
                              child: 
                                Text('Generating conclusion. Please wait...'),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
      CustomDropdownWithSearch( 
          items: userState.patientNames,
          itemName: 'Patient name',
          dState: 0
        ),
ListTile(
  title: const Text('Other'),
  leading: Checkbox(
    value: other,
    onChanged: (bool? value) {
      setState(() {
        bDate = null;
        other = value!;
      });
    },
  ),
),

        other ?
        Column(children: [
          Row(
            children: [
Expanded(child: 
    TextField(
      decoration: const InputDecoration(labelText: 'Patient name'),
      onChanged: (value) => setState(() => name = value),
    ),
),

const SizedBox(width: 16.0),
    // Date of birth
Expanded(child: 
    TextButton(
      onPressed: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (picked != null && picked != bDate)
          setState(() {
            bDate = picked;
          });
      },
      child: Text(bDate != null ? bDate!.toIso8601String().split('T')[0] : 'Select date of birth'),
    ),
    ),
          ],),

      const SizedBox(height: 16.0),

          ElevatedButton(
            onPressed: () {
              AppLog.log().i('name: $name, bDate: $bDate');

              if (name != null && bDate != null) {
                String bYear = bDate!.year.toString();
                StoreProvider.of<GlobalState>(context).dispatch(
                  SaveNewPatientAction(name!, bYear),
                );
              }
            },
            child: Text('Save patient'),
            )
        ],) : Container(),

    TextField(
      decoration: const InputDecoration(labelText: 'Scanning Technique'),
      onChanged: (value) => setState(() => observation.scanningTechnique = value),
    ),
    TextField(
      decoration: const InputDecoration(labelText: 'Basal Ganglia Location'),
      onChanged: (value) => setState(() => observation.basalGangliaLocation = value),
    ),
    TextField(
      decoration: const InputDecoration(labelText: 'Basal Ganglia Symmetry'),
      onChanged: (value) => setState(() => observation.basalGangliaSymmetry = value),
    ),
    TextField(
      decoration: const InputDecoration(labelText: 'Basal Ganglia Contour'),
      onChanged: (value) => setState(() => observation.basalGangliaContour = value),
    ),
    TextField(
      decoration: const InputDecoration(labelText: 'Basal Ganglia Dimensions'),
      onChanged: (value) => setState(() => observation.basalGangliaDimensions = value),
    ),
    TextField(
      decoration: const InputDecoration(labelText: 'Basal Ganglia Signal'),
      onChanged: (value) => setState(() => observation.basalGangliaSignal = value),
    ),
    TextField(
      decoration: const InputDecoration(labelText: 'Lateral Ventricles Width Right (mm)'),
      keyboardType: TextInputType.number,
      onChanged: (value) => setState(() => observation.lateralVentriclesWidthRight = double.tryParse(value) ?? 0.0),
    ),
    TextField(
      decoration: const InputDecoration(labelText: 'Lateral Ventricles Width Left (mm)'),
      keyboardType: TextInputType.number,
      onChanged: (value) => setState(() => observation.lateralVentriclesWidthLeft = double.tryParse(value) ?? 0.0),
    ),
    TextField(
      decoration: const InputDecoration(labelText: 'Third Ventricle Width (mm)'),
      keyboardType: TextInputType.number,
      onChanged: (value) => setState(() => observation.thirdVentricleWidth = double.tryParse(value) ?? 0.0),
    ),
    TextField(
      decoration: const InputDecoration(labelText: 'Sylvian Aqueduct Condition'),
      onChanged: (value) => setState(() => observation.sylvianAqueductCondition = value),
    ),
    TextField(
      decoration: const InputDecoration(labelText: 'Fourth Ventricle Condition'),
      onChanged: (value) => setState(() => observation.fourthVentricleCondition = value),
    ),
    TextField(
      decoration: const InputDecoration(labelText: 'Corpus Callosum Condition'),
      onChanged: (value) => setState(() => observation.corpusCallosumCondition = value),
    ),
    TextField(
      decoration: const InputDecoration(labelText: 'Brain Stem Condition'),
      onChanged: (value) => setState(() => observation.brainStemCondition = value),
    ),
    TextField(
      decoration: const InputDecoration(labelText: 'Cerebellum Condition'),
      onChanged: (value) => setState(() => observation.cerebellumCondition = value),
    ),
    TextField(
      decoration: const InputDecoration(labelText: 'Craniovertebral Junction Condition'),
      onChanged: (value) => setState(() => observation.craniovertebralJunctionCondition = value),
    ),
    TextField(
      decoration: const InputDecoration(labelText: 'Pituitary Gland Condition'),
      onChanged: (value) => setState(() => observation.pituitaryGlandCondition = value),
    ),
    TextField(
      decoration: const InputDecoration(labelText: 'Orbital Cones Shape'),
      onChanged: (value) => setState(() => observation.orbitalConesShape = value),
    ),
    TextField(
      decoration: const InputDecoration(labelText: 'Eyeballs Shape and Size'),
      onChanged: (value) => setState(() => observation.eyeballsShapeSize = value),
    ),
    TextField(
      decoration: const InputDecoration(labelText: 'Optic Nerves Diameter (mm)'),
      keyboardType: TextInputType.number,
      onChanged: (value) => setState(() => observation.opticNervesDiameter = double.tryParse(value) ?? 0.0),
    ),
    TextField(
      decoration: const InputDecoration(labelText: 'Extraocular Muscles Condition'),
      onChanged: (value) => setState(() => observation.extraocularMusclesCondition = value),
    ),
    TextField(
      decoration: const InputDecoration(labelText: 'Retrobulbar Fatty Tissue Condition'),
      onChanged: (value) => setState(() => observation.retrobulbarFattyTissueCondition = value),
    ),

    ListTile(
  title: const Text('Cysts Presence in Paranasal Sinuses'),
  leading: Checkbox(
    value: observation.sinusesCystsPresence,
    onChanged: (bool? value) {
      setState(() {
        observation.sinusesCystsPresence = value!;
      });
    },
  ),
),
    TextField(
      decoration: const InputDecoration(labelText: 'Cysts Size (mm)'),
      keyboardType: TextInputType.number,
      onChanged: (value) => setState(() => observation.sinusesCystsSize = double.tryParse(value) ?? 0.0),
    ),
    TextField(
      decoration: const InputDecoration(labelText: 'Sinuses Pneumatization'),
      onChanged: (value) => setState(() => observation.sinusesPneumatization = value),
    ),
    TextField(
      decoration: const InputDecoration(labelText: 'Additional Observations'),
      onChanged: (value) => setState(() => observation.additionalObservations = value),
    ),
          
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: _generateConclusion,
            child: Text(
              userState.conclusion.isEmpty ? 'Generate Conclusion' : 'Regenerate Conclusion'
            ),
          ),

          if (userState.conclusion.isNotEmpty)
            Text(
              'Conclusion:\n${userState.conclusion}'
            ),

          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: showDialoga,
            child: Text('Submit'),
          ),
        ],
      ),
    );
      },
    );
  }
}
