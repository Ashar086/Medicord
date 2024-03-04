import 'package:brainmri/screens/observation/brain/brain_observation_form.dart';
import 'package:brainmri/screens/user/user_reducer.dart';
import 'package:brainmri/store/app_store.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../utils/refreshable.dart';

class AddObservationScreen extends StatefulWidget {
  const AddObservationScreen({super.key});

  @override
  State<AddObservationScreen> createState() => _AddObservationScreenState();
}

class _AddObservationScreenState extends State<AddObservationScreen> {
  String _selectedOption = '';


      void reFetchData()  {
          print('refetching');
          if (_selectedOption == 'Brain')
            {
              store.dispatch(FetchAllPatientNamesAction());

          }
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
    return Scaffold(
      body:
    Refreshable(
            refreshController: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: 
    SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DropdownButton<String>(
            alignment: AlignmentDirectional.center,
            value: _selectedOption.isEmpty ? null : _selectedOption,
            hint: const Text('Select an Option'),
            items: const [
              DropdownMenuItem(value: 'Brain', child: Text('Brain')),
              DropdownMenuItem(value: 'Lunger', child: Text('Lunger')),
              DropdownMenuItem(value: 'Spine', child: Text('Spine')),
              DropdownMenuItem(value: 'Heart', child: Text('Heart')),
              DropdownMenuItem(value: 'Knee', child: Text('Knee')),
            ],
            onChanged: (value) {
              setState(() {
                _selectedOption = value ?? '';
              });
            },
          ),
          if (_selectedOption == 'Brain')
            const BrainObservationForm(),
          if (_selectedOption == 'Lunger')
          const Center(child: 
            const Text('We are working on that. Stay tuned!'),
          ),
          if (_selectedOption == 'Spine')
          const Center(child: 
            const Text('We are working on that. Stay tuned!'),
          ),
          if (_selectedOption == 'Heart')
          const Center(child: 
            const Text('We are working on that. Stay tuned!'),
          ),
          if (_selectedOption == 'Knee')
          const Center(child: 
            const Text('We are working on that. Stay tuned!'),
          ),
        ],
      ),
      ),
      ),
    );
  }
}
