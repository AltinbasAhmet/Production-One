import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/project.dart';

class ProjectSystemScreen extends StatefulWidget {
  final List<String> factoryOptions;

  const ProjectSystemScreen({Key? key, required this.factoryOptions}) : super(key: key);

  @override
  State<ProjectSystemScreen> createState() => _ProjectSystemScreenState();
}

class _ProjectSystemScreenState extends State<ProjectSystemScreen> {
  late Box<Project> projectBox;
  final Set<int> _expandedIndexes = {};

  @override
  void initState() {
    super.initState();
    projectBox = Hive.box<Project>('projects');
  }

  void _showAddProjectDialog() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController managerController = TextEditingController();
    final TextEditingController contributorsController = TextEditingController();
    final TextEditingController costController = TextEditingController();

    DateTime? startDate;
    DateTime? endDate;
    String? selectedFactory;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Yeni Proje Ekle'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Proje Başlığı'),
                ),
                TextField(
                  controller: managerController,
                  decoration: const InputDecoration(labelText: 'Proje Yöneticisi'),
                ),
                TextField(
                  controller: contributorsController,
                  decoration: const InputDecoration(labelText: 'Katkıda Bulunanlar'),
                ),
                Row(
                  children: [
                    const Text('Başlangıç:'),
                    const SizedBox(width: 10),
                    TextButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setState(() {
                            startDate = picked;
                          });
                        }
                      },
                      child: Text(startDate == null ? 'Seçiniz' : startDate!.toLocal().toString().split(' ')[0]),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('Bitiş:'),
                    const SizedBox(width: 10),
                    TextButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setState(() {
                            endDate = picked;
                          });
                        }
                      },
                      child: Text(endDate == null ? 'Seçiniz' : endDate!.toLocal().toString().split(' ')[0]),
                    ),
                  ],
                ),
                TextField(
                  controller: costController,
                  decoration: const InputDecoration(labelText: 'Planlanan Maliyet'),
                  keyboardType: TextInputType.number,
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Fabrika'),
                  items: ['Genel', ...widget.factoryOptions]
                      .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                      .toList(),
                  onChanged: (value) {
                    selectedFactory = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    managerController.text.isNotEmpty &&
                    contributorsController.text.isNotEmpty &&
                    startDate != null &&
                    endDate != null &&
                    costController.text.isNotEmpty &&
                    selectedFactory != null) {
                  final newProject = Project(
                    title: titleController.text,
                    manager: managerController.text,
                    contributors: contributorsController.text,
                    startDate: startDate!,
                    endDate: endDate!,
                    estimatedCost: double.tryParse(costController.text) ?? 0,
                    factory: selectedFactory!,
                  );
                  projectBox.add(newProject);
                  Navigator.pop(context);
                }
              },
              child: const Text('Kaydet'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Proje Yönetimi'),
      ),
      body: ValueListenableBuilder(
        valueListenable: projectBox.listenable(),
        builder: (context, Box<Project> box, _) {
          final projects = box.values.toList();

          return ListView.builder(
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final project = projects[index];
              final isExpanded = _expandedIndexes.contains(index);

              return Card(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      if (isExpanded) {
                        _expandedIndexes.remove(index);
                      } else {
                        _expandedIndexes.add(index);
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(project.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        if (isExpanded) ...[
                          const SizedBox(height: 10),
                          Text('Yönetici: ${project.manager}'),
                          Text('Katkıda Bulunanlar: ${project.contributors}'),
                          Text('Başlangıç: ${project.startDate.toLocal().toString().split(' ')[0]}'),
                          Text('Bitiş: ${project.endDate.toLocal().toString().split(' ')[0]}'),
                          Text('Maliyet: ₺${project.estimatedCost.toStringAsFixed(2)}'),
                          Text('Fabrika: ${project.factory}'),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddProjectDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}