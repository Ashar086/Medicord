import 'package:brainmri/models/observation_mode.dart';
import 'package:brainmri/models/patients_model.dart';
import 'package:brainmri/screens/user/user_reducer.dart';
import 'package:brainmri/store/app_store.dart';
import 'package:brainmri/utils/refreshable.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class AllObservationsScreen extends StatefulWidget {
  const AllObservationsScreen({super.key});

  @override
  State<AllObservationsScreen> createState() => _AllObservationsScreenState();
}

class _AllObservationsScreenState extends State<AllObservationsScreen> {

  @override
  void initState() {
    super.initState();
  }

  void reFetchData()  {
      StoreProvider.of<GlobalState>(context).dispatch(FetchAllPatients());
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

    void _showDialogr(PatientModel patient) {

    print('_showDialogr patient: ${patient.fullName}');


      var state = StoreProvider.of<GlobalState>(context).state.appState.userState;

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Report'),
            content: Text('Are you sure you want to generate report?'),
            actions: <Widget>[
                      if (state.isGeneratingReport)
                        const Column(
                          children: [
                            LinearProgressIndicator(),
                            Padding(padding: EdgeInsets.only(left:16.0, right:16.0),
                              child: 
                                Text('Generating Report. Please wait...'),
                            ),
                          ],
                        ),
if (state.reportPath.isNotEmpty)
  TextButton(
    onPressed: () async {
      String path = state.reportPath;
      print('path: $path');

                  StoreProvider.of<GlobalState>(context).dispatch(
        DownloadReportAction(path),
      );
    },
    child: const Text('Download Report'),
  ),

  const SizedBox(height: 16.0),

  Row(
    children: [
Expanded(child: 
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
),
Expanded(child: 
              TextButton(
                onPressed: () {
                             StoreProvider.of<GlobalState>(context).dispatch(
        GenerateReportAction(patient),
      );
                },
                child: const Text('Generate'),
              ),
              ),
    ],
  )

            ],
          );
        },
      );
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Refreshable(
            refreshController: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: 
      StoreConnector<GlobalState, UserState>(
      onInit: (store) {
        store.dispatch(FetchAllPatients());
      },
      converter: (appState) => appState.state.appState.userState,
      builder: (context, userState) {
        
        return
        userState.patientsList.isEmpty ? 
        const Center(child: CircularProgressIndicator()) :

        Padding(
          padding: const EdgeInsets.all(20),
        child:
      SingleChildScrollView(
  scrollDirection: Axis.vertical,
  child: SingleChildScrollView(
    scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Full Name')),
            DataColumn(label: Text('Birth Year')),
            DataColumn(label: Text('Observations')),
            DataColumn(label: Text('Report')),
          ],
          rows: userState.patientsList
              .map(
                (patient) => DataRow(cells: [
                  DataCell(Text(patient.fullName!)),
                  DataCell(Text(patient.birthYear!.toString())),
                  DataCell(
                    IconButton(
                      icon: const Icon(Icons.visibility),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ObservationsScreen(
                              pId: patient.id!,
                              observations: patient.observations!,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  DataCell(
                    IconButton(
                      icon: const Icon(Icons.file_copy),
                      onPressed: () {
                        _showDialogr(patient);
                      },
                    ),
                  ),
                ]),
              )
              .toList(),
        ),
        ),
        ),
      );
      }
      ),
      ),
    );
  }
}




class ObservationsScreen extends StatefulWidget {
  final String pId;
  final List<ObservationModel> observations;

  const ObservationsScreen({Key? key, required this.pId, required this.observations}) : super(key: key);

  @override
  State<ObservationsScreen> createState() => _ObservationsScreenState();
}

class _ObservationsScreenState extends State<ObservationsScreen> {
  late List<ObservationModel> observations;

  @override
  void initState() {
    super.initState();
    observations = widget.observations;
  }

    String headDoctorName = '';
    String obId = '';

    void showDialoga() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Head Doctor Name'),
            content: TextField(
              onChanged: (value) => setState(() => headDoctorName = value),
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
                child: const Text('Approve'),
              ),
            ],
          );
        },
      );
    }

    void _submitForm() {

      var state = StoreProvider.of<GlobalState>(context).state.appState.userState;

      StoreProvider.of<GlobalState>(context).dispatch(
        ApprovePatientConclusionAction(widget.pId, obId, headDoctorName),
      );

      Navigator.of(context).pop();
    }

    void showDialogb() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Approved'),
            content: Text('This observation has already been approved.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
            ],
          );
        },
      );
    }

  

    TextEditingController conclusionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Observations'),
      ),
      body: 
      Padding(padding: 
      const EdgeInsets.all(20),
      child:
      SingleChildScrollView(
  scrollDirection: Axis.vertical,
  child: SingleChildScrollView(
    scrollDirection: Axis.horizontal,
        child: 
        DataTable(
          columns: const [
            DataColumn(label: Text('Observation')),
            DataColumn(label: Text('Observed At')),
            DataColumn(label: Text('Radiologist Name')),
            DataColumn(label: Text('Conclusion')),
            DataColumn(label: Text('Approved')),
          ],
          rows: observations
              .map(
                (observation) => DataRow(cells: [
                  DataCell(InkWell(
                    onTap: () => showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Observation'),
                          content: SingleChildScrollView(
  scrollDirection: Axis.vertical,
  child:Text(observation.text!),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Close'),
                            ),
                          ],
                        );
                      },
                    ),
                    child:
                    Text(
                    observation.text!,
                    overflow: TextOverflow.ellipsis,
                  )),
                  ),
                  DataCell(Text(observation.observedAt!.toString())),
                  DataCell(Text(observation.radiologistName!)),
                  DataCell(
                   InkWell(
  onTap: () => showDialog(
    context: context,
    builder: (BuildContext context) {
      bool isEdited = false;
      TextEditingController conclusionController = TextEditingController(text: observation.conclusion!.text!);

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Conclusion'),
            content: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: TextField(
                controller: conclusionController,
                onChanged: (value) {
                  setState(() {
                    isEdited = value != observation.conclusion!.text!;
                  });
                },
              ),
            ),
            actions: <Widget>[
              if (isEdited)
                ElevatedButton(
                  onPressed: () {
                    print('update conclusion');

                    StoreProvider.of<GlobalState>(context).dispatch(
                      UpdatePatientConclusion(
                        widget.pId,
                        observation.id!,
                        conclusionController.text,
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                  child: const Text('Save'),
                ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    },
  ),
  child: Text(observation.conclusion!.text!),
),
),

                  DataCell(
                    IconButton(
                      icon: observation.conclusion!.isApproved! ? 
                      const Icon(Icons.check_circle_outline) :
                      const Icon(Icons.cancel_outlined),
                      onPressed: () {
                        setState(() {
                          obId = observation.id!;
                        });
                        !observation.conclusion!.isApproved! ? 
                        showDialoga() : showDialogb();
                      },
                    ),
                  ),
                ]),
              )
              .toList(),
        ),
      ),
      ),
      ),
    );
  }
}
