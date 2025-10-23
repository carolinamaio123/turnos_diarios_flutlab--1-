import 'package:flutter/material.dart';
import '../models/shift.dart';
import '../models/category.dart';

class PersonDetailsPage extends StatefulWidget {
  final Shift shift;
  
  const PersonDetailsPage({super.key, required this.shift});

  @override
  State<PersonDetailsPage> createState() => _PersonDetailsPageState();
}

class _PersonDetailsPageState extends State<PersonDetailsPage> {
  // Dados editáveis
  String _phoneNumber = '+351 912 345 678';
  String _email = '';
  String _emergencyContact = '+351 913 456 789 (Maria Silva)';
  String _notes = 'Funcionário dedicado e pontual. Excelente trabalho em equipa. Necessita de formação adicional em sistema de gestão.';
  Map<String, String> _weeklySchedule = {
    'Segunda': '09:00 - 17:00',
    'Terça': '09:00 - 17:00',
    'Quarta': 'FOLGA',
    'Quinta': '09:00 - 17:00',
    'Sexta': '09:00 - 17:00',
    'Sábado': '08:00 - 12:00',
    'Domingo': 'FOLGA',
  };
  List<Map<String, dynamic>> _trainings = [
    {'title': 'Segurança no Trabalho', 'status': 'Concluída - 15/03/2024', 'completed': true},
    {'title': 'Atendimento ao Cliente', 'status': 'Concluída - 22/02/2024', 'completed': true},
    {'title': 'Gestão de Stock', 'status': 'Pendente - Prevista Jun/2024', 'completed': false},
    {'title': 'Novo Software ERP', 'status': 'Agendada - 15/05/2024', 'completed': false},
  ];
  List<Map<String, dynamic>> _vacations = [
    {'period': '01 Agosto 2024 - 15 Agosto 2024', 'duration': '15 dias', 'status': 'Aprovado'},
    {'period': '20 Dezembro 2024 - 03 Janeiro 2025', 'duration': '11 dias', 'status': 'Aprovado'},
    {'period': '15 Março 2025 - 22 Março 2025', 'duration': '6 dias', 'status': 'Pendente'},
  ];

  @override
  void initState() {
    super.initState();
    // Inicializar email baseado no nome
    _email = '${widget.shift.name.toLowerCase().replaceAll(' ', '.')}@empresa.pt';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.shift.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              background: Container(color: widget.shift.color),
            ),
            backgroundColor: widget.shift.color,
            pinned: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: _showEditOptions,
              ),
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
          
          SliverList(
            delegate: SliverChildListDelegate([
              _buildHeaderSection(),
              _buildContactSection(),
              _buildCategorySection(),
              _buildWeeklyTimeOffSection(),
              _buildNotesSection(),
              _buildTrainingsSection(),
              _buildEvaluationsSection(),
              _buildVacationsSection(),
              const SizedBox(height: 80),
            ]),
          ),
        ],
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showQuickActions(context),
        backgroundColor: widget.shift.color,
        child: const Icon(Icons.phone, color: Colors.white),
      ),
    );
  }

  // ============ SEÇÕES EDITÁVEIS ============

  Widget _buildHeaderSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: widget.shift.color,
            child: Text(
              _getInitials(widget.shift.name),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.shift.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Horário: ${_formatTime(widget.shift.start)} - ${_formatTime(widget.shift.end)}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Duração: ${widget.shift.netDuration.inHours}h',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return _buildSection(
      title: 'Contactos',
      icon: Icons.contact_phone,
      onEdit: () => _editContactInfo(),
      children: [
        _buildContactItem(
          icon: Icons.phone,
          label: 'Telemóvel',
          value: _phoneNumber,
          onTap: () => _makePhoneCall(_phoneNumber),
        ),
        _buildContactItem(
          icon: Icons.email,
          label: 'Email',
          value: _email,
          onTap: () => _sendEmail(_email),
        ),
        _buildContactItem(
          icon: Icons.emergency,
          label: 'Contacto de Emergência',
          value: _emergencyContact,
          onTap: () => _makePhoneCall(_emergencyContact),
        ),
      ],
    );
  }

  Widget _buildCategorySection() {
    final category = categories[widget.shift.category]!;
    
    return _buildSection(
      title: 'Categoria',
      icon: Icons.work,
      children: [
        ListTile(
          leading: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: category.color,
              shape: BoxShape.circle,
            ),
          ),
          title: Text(
            category.label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          subtitle: Text('Letra: ${category.letter}'),
          trailing: Chip(
            label: Text(
              category.letter,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: category.color,
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyTimeOffSection() {
    return _buildSection(
      title: 'Plano de Folgas Semanal',
      icon: Icons.calendar_today,
      onEdit: () => _editWeeklySchedule(),
      children: _weeklySchedule.entries.map((entry) {
        return _buildScheduleDay(entry.key, entry.value);
      }).toList(),
    );
  }

  Widget _buildNotesSection() {
    return _buildSection(
      title: 'Notas',
      icon: Icons.note,
      onEdit: () => _editNotes(),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: Text(
            _notes,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrainingsSection() {
    return _buildSection(
      title: 'Formações',
      icon: Icons.school,
      onEdit: () => _editTrainings(),
      children: _trainings.map((training) {
        return _buildTrainingItem(
          training['title'] as String,
          training['status'] as String,
          training['completed'] as bool ? Icons.check_circle : Icons.pending,
          training['completed'] as bool ? Colors.green : Colors.orange,
        );
      }).toList(),
    );
  }

  Widget _buildEvaluationsSection() {
    return _buildSection(
      title: 'Avaliações',
      icon: Icons.star,
      children: [
        _buildEvaluationItem(
          'Avaliação Trimestral - Mar/2024',
          '4.5/5.0',
          'Excelente desempenho e proatividade',
        ),
        _buildEvaluationItem(
          'Avaliação Anual - 2023',
          '4.2/5.0',
          'Bom trabalho em equipa, áreas de melhoria identificadas',
        ),
        _buildEvaluationItem(
          'Avaliação Trimestral - Dez/2023',
          '4.0/5.0',
          'Progresso consistente, cumpre prazos',
        ),
      ],
    );
  }

  Widget _buildVacationsSection() {
    return _buildSection(
      title: 'Férias Marcadas',
      icon: Icons.beach_access,
      onEdit: () => _editVacations(),
      children: _vacations.map((vacation) {
        return _buildVacationItem(
          vacation['period'] as String,
          vacation['duration'] as String,
          vacation['status'] as String,
          vacation['status'] == 'Aprovado' ? Colors.green : Colors.orange,
        );
      }).toList(),
    );
  }

  // ============ COMPONENTES REUTILIZÁVEIS ============

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
    VoidCallback? onEdit,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: widget.shift.color, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (onEdit != null)
                  IconButton(
                    icon: Icon(Icons.edit, color: widget.shift.color, size: 20),
                    onPressed: onEdit,
                  ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: widget.shift.color, size: 22),
      title: Text(label),
      subtitle: Text(value),
      trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
      onTap: onTap,
    );
  }

  Widget _buildScheduleDay(String day, String schedule) {
    return ListTile(
      leading: Container(
        width: 40,
        alignment: Alignment.center,
        child: Text(
          day.substring(0, 3),
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: schedule == 'FOLGA' ? Colors.red : Colors.green,
          ),
        ),
      ),
      title: Text(day),
      trailing: Text(
        schedule,
        style: TextStyle(
          color: schedule == 'FOLGA' ? Colors.red : Colors.green,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTrainingItem(String title, String status, IconData icon, Color color) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      subtitle: Text(status),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
    );
  }

  Widget _buildEvaluationItem(String period, String rating, String comments) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: widget.shift.color.withOpacity(0.2),
        child: Text(
          rating.split('/')[0],
          style: TextStyle(color: widget.shift.color, fontWeight: FontWeight.bold),
        ),
      ),
      title: Text(period),
      subtitle: Text(comments, maxLines: 2, overflow: TextOverflow.ellipsis),
    );
  }

  Widget _buildVacationItem(String period, String duration, String status, Color statusColor) {
    return ListTile(
      leading: Container(
        width: 4,
        height: 40,
        decoration: BoxDecoration(
          color: statusColor,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      title: Text(period),
      subtitle: Text(duration),
      trailing: Chip(
        label: Text(
          status,
          style: const TextStyle(fontSize: 12, color: Colors.white),
        ),
        backgroundColor: statusColor,
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }

  // ============ MÉTODOS DE EDIÇÃO ============

  void _showEditOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Editar Informações',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildEditOption(Icons.contact_phone, 'Contactos', _editContactInfo),
            _buildEditOption(Icons.calendar_today, 'Horário Semanal', _editWeeklySchedule),
            _buildEditOption(Icons.note, 'Notas', _editNotes),
            _buildEditOption(Icons.school, 'Formações', _editTrainings),
            _buildEditOption(Icons.beach_access, 'Férias', _editVacations),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditOption(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: widget.shift.color),
      title: Text(label),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  void _editContactInfo() {
    final phoneController = TextEditingController(text: _phoneNumber);
    final emailController = TextEditingController(text: _email);
    final emergencyController = TextEditingController(text: _emergencyContact);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Contactos'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildEditField('Telemóvel', phoneController, Icons.phone),
              _buildEditField('Email', emailController, Icons.email),
              _buildEditField('Contacto Emergência', emergencyController, Icons.emergency),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _phoneNumber = phoneController.text;
                _email = emailController.text;
                _emergencyContact = emergencyController.text;
              });
              Navigator.pop(context);
              _showSuccessMessage('Contactos atualizados com sucesso!');
            },
            style: ElevatedButton.styleFrom(backgroundColor: widget.shift.color),
            child: const Text('Guardar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _editWeeklySchedule() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Editar Horário Semanal'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: _weeklySchedule.entries.map((entry) {
                  final day = entry.key;
                  final schedule = entry.value;
                  final controller = TextEditingController(text: schedule);
                  
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 80,
                          child: Text(day, style: const TextStyle(fontWeight: FontWeight.w500)),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            controller: controller,
                            decoration: const InputDecoration(
                              hintText: 'Ex: 09:00-17:00 ou FOLGA',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 8),
                            ),
                            onChanged: (value) {
                              setDialogState(() {
                                _weeklySchedule[day] = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {});
                  Navigator.pop(context);
                  _showSuccessMessage('Horário semanal atualizado!');
                },
                style: ElevatedButton.styleFrom(backgroundColor: widget.shift.color),
                child: const Text('Guardar', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }

  void _editNotes() {
    final notesController = TextEditingController(text: _notes);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Notas'),
        content: TextFormField(
          controller: notesController,
          maxLines: 8,
          decoration: const InputDecoration(
            hintText: 'Escreva as notas aqui...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _notes = notesController.text;
              });
              Navigator.pop(context);
              _showSuccessMessage('Notas atualizadas com sucesso!');
            },
            style: ElevatedButton.styleFrom(backgroundColor: widget.shift.color),
            child: const Text('Guardar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _editTrainings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Gerir Formações'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ..._trainings.asMap().entries.map((entry) {
                final index = entry.key;
                final training = entry.value;
                final titleController = TextEditingController(text: training['title'] as String);
                final statusController = TextEditingController(text: training['status'] as String);

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: titleController,
                          decoration: const InputDecoration(labelText: 'Formação'),
                          onChanged: (value) {
                            _trainings[index]['title'] = value;
                          },
                        ),
                        TextFormField(
                          controller: statusController,
                          decoration: const InputDecoration(labelText: 'Status'),
                          onChanged: (value) {
                            _trainings[index]['status'] = value;
                          },
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: training['completed'] as bool,
                              onChanged: (value) {
                                setState(() {
                                  _trainings[index]['completed'] = value;
                                });
                              },
                            ),
                            const Text('Concluída'),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  _trainings.removeAt(index);
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _trainings.add({
                      'title': 'Nova Formação',
                      'status': 'Pendente',
                      'completed': false,
                    });
                  });
                },
                icon: const Icon(Icons.add),
                label: const Text('Adicionar Formação'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {});
              Navigator.pop(context);
              _showSuccessMessage('Formações atualizadas!');
            },
            style: ElevatedButton.styleFrom(backgroundColor: widget.shift.color),
            child: const Text('Guardar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _editVacations() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Gerir Férias'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ..._vacations.asMap().entries.map((entry) {
                final index = entry.key;
                final vacation = entry.value;
                final periodController = TextEditingController(text: vacation['period'] as String);
                final durationController = TextEditingController(text: vacation['duration'] as String);

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: periodController,
                          decoration: const InputDecoration(labelText: 'Período'),
                          onChanged: (value) {
                            _vacations[index]['period'] = value;
                          },
                        ),
                        TextFormField(
                          controller: durationController,
                          decoration: const InputDecoration(labelText: 'Duração'),
                          onChanged: (value) {
                            _vacations[index]['duration'] = value;
                          },
                        ),
                        DropdownButtonFormField<String>(
                          value: vacation['status'] as String,
                          items: ['Aprovado', 'Pendente', 'Cancelado']
                              .map((status) => DropdownMenuItem(
                                    value: status,
                                    child: Text(status),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _vacations[index]['status'] = value;
                            });
                          },
                          decoration: const InputDecoration(labelText: 'Status'),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                _vacations.removeAt(index);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _vacations.add({
                      'period': 'Nova data - Nova data',
                      'duration': '0 dias',
                      'status': 'Pendente',
                    });
                  });
                },
                icon: const Icon(Icons.add),
                label: const Text('Adicionar Férias'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {});
              Navigator.pop(context);
              _showSuccessMessage('Férias atualizadas!');
            },
            style: ElevatedButton.styleFrom(backgroundColor: widget.shift.color),
            child: const Text('Guardar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildEditField(String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ============ MÉTODOS UTILITÁRIOS ============

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts.first[0].toUpperCase()}${parts.last[0].toUpperCase()}';
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  void _makePhoneCall(String phoneNumber) {
    // TODO: Implementar chamada telefónica
    print('Chamar: $phoneNumber');
  }

  void _sendEmail(String email) {
    // TODO: Implementar envio de email
    print('Enviar email para: $email');
  }

  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.phone, color: widget.shift.color),
              title: const Text('Ligar'),
              onTap: () {
                Navigator.pop(context);
                _makePhoneCall(_phoneNumber);
              },
            ),
            ListTile(
              leading: Icon(Icons.message, color: widget.shift.color),
              title: const Text('Mensagem'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implementar SMS
              },
            ),
            ListTile(
              leading: Icon(Icons.email, color: widget.shift.color),
              title: const Text('Email'),
              onTap: () {
                Navigator.pop(context);
                _sendEmail(_email);
              },
            ),
          ],
        ),
      ),
    );
  }
}
