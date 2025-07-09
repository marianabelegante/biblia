import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controller/study_library_controller.dart';
import '../model/study_model.dart';

class StudyLibraryView extends StatefulWidget {
  const StudyLibraryView({super.key});

  @override
  State<StudyLibraryView> createState() => _StudyLibraryViewState();
}

class _StudyLibraryViewState extends State<StudyLibraryView> {
  final StudyLibraryController _controller = StudyLibraryController();
  late Future<List<Study>> _studiesFuture;

  @override
  void initState() {
    super.initState();
    _studiesFuture = _controller.fetchSavedStudies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Estudos Salvos'),
      ),
      body: FutureBuilder<List<Study>>(
        future: _studiesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Erro: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Nenhum estudo salvo ainda.'),
            );
          }

          final studies = snapshot.data!;
          return ListView.builder(
            itemCount: studies.length,
            itemBuilder: (context, index) {
              final study = studies[index];
              // Format the date
              final formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(study.createdAt);
              
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(study.verse, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Salvo em: $formattedDate'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => _controller.navigateToStudyDetail(context, study),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
