import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../data/models/activity_model.dart';
import '../../../../../data/models/user_model.dart';
import '../../../../../data/services/activity_service.dart';
import '../../../../../data/services/project_context_service.dart';
import '../../../../../data/services/user_service.dart';
import '../../../../../data/services/session_service.dart';
import '../../../../../data/services/observation_service.dart';
import '../../../../../data/models/observation_model.dart';
import '../../../../../shared/controllers/base_form_controller.dart';
import '../../../../../shared/validators/validators.dart' as validators;

class ActivityFormController extends BaseFormController {
  // Services
  final ActivityService _activityService = Get.find<ActivityService>();
  final UserService _userService = Get.find<UserService>();
  final SessionService _sessionService = Get.find<SessionService>();
  final ProjectContextService _projectContextService =
      Get.find<ProjectContextService>();
  final ObservationService _observationService = Get.put(ObservationService());

  // Activity data
  final Rx<ActivityModel> activity = ActivityModel(
    projectId: 0,
    description: '',
    stateId: 1,
  ).obs;

  // Form controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  // Observable fields
  final startDate = Rxn<DateTime>();
  final endDate = Rxn<DateTime>();
  final RxList<UserModel> managers = <UserModel>[].obs;
  final RxList<ActivityModel> dependencies = <ActivityModel>[].obs;
  final observationText = ''.obs; // For storing observation text

  // Loading state
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();

    if (_projectContextService.currentProject != null) {
      activity.update((val) {
        val?.projectId = _projectContextService.currentProject!.id;
      });
    }

    _loadManagers();
    _loadProjectActivities();
  }

  @override
  void onClose() {
    _disposeControllers();
    super.onClose();
  }

  void _initializeControllers() {
    titleController.text = activity.value.title ?? '';
    descriptionController.text = activity.value.description;
    startDate.value = activity.value.startDate;
    endDate.value = activity.value.endDate;
  }

  void _disposeControllers() {
    titleController.dispose();
    descriptionController.dispose();
  }

  /// Loads users with roles 2 (Promotor) and 3 (Captador) as potential activity managers
  Future<void> _loadManagers() async {
    try {
      isLoading(true);

      // Get only users with roles 2 and 3
      final usersList = await _userService.getUsersByRoles([2, 3]);

      // Log for debugging
      print(
          'Loaded managers: ${usersList.map((e) => "${e.name} (${e.roleId})").join(', ')}');

      managers.assignAll(usersList);

      // Pre-select the current user if they are eligible (role 2 or 3)
      if (_sessionService.currentUser != null &&
          ((_sessionService.currentUser!.roleId == 2 ||
              _sessionService.currentUser!.roleId == 3))) {
        activity.update((val) {
          val?.managerId = _sessionService.currentUser!.id;
        });
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error al cargar los responsables: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> _loadProjectActivities() async {
    try {
      if (_projectContextService.currentProject != null) {
        isLoading(true);
        final projectId = _projectContextService.currentProject!.id;
        final activitiesList =
            await _activityService.getActivitiesByProject(projectId);

        // Don't include the current activity as a potential dependency
        if (activity.value.id > 0) {
          dependencies.assignAll(
              activitiesList.where((a) => a.id != activity.value.id));
        } else {
          dependencies.assignAll(activitiesList);
        }
      }
    } catch (e) {
      print('Error loading project activities: $e');
    } finally {
      isLoading(false);
    }
  }

  void loadActivity(ActivityModel model) {
    activity.value = model;
    _initializeControllers();
    _loadObservation(model.id);
  }

  /// Loads existing observation for this activity
  Future<void> _loadObservation(int activityId) async {
    try {
      if (activityId > 0) {
        final observations = await _observationService.getObservationsBySource(
            'activities', activityId);
        if (observations.isNotEmpty) {
          // Take the most recent observation
          final latestObservation = observations
              .reduce((a, b) => a.createdAt.isAfter(b.createdAt) ? a : b);
          observationText.value = latestObservation.observation;
        }
      }
    } catch (e) {
      print('Error loading observation: $e');
    }
  }

  void updateActivity({
    String? title,
    String? description,
    int? managerId,
    DateTime? startDate,
    DateTime? endDate,
    int? dependencyId,
    int? stateId,
  }) {
    activity.update((val) {
      if (val != null) {
        if (title != null) {
          val.title = title;
          activity.value.title = title;
        }
        if (description != null) {
          val.description = description;
          activity.value.description = description;
        }
        if (managerId != null) {
          val.managerId = managerId;
          activity.value.managerId = managerId;
        }
        if (startDate != null) {
          val.startDate = startDate;
          activity.value.startDate = startDate;
          this.startDate.value = startDate;
        }
        if (endDate != null) {
          val.endDate = endDate;
          activity.value.endDate = endDate;
          this.endDate.value = endDate;
        }
        if (dependencyId != null) {
          val.dependencyId = dependencyId;
          activity.value.dependencyId = dependencyId;
        }
        if (stateId != null) {
          val.stateId = stateId;
          activity.value.stateId = stateId;
        }
      }
    });
  }

  // Update observation text
  void updateObservation(String text) {
    observationText.value = text;
  }

  // Validations
  String? validateTitle(String? value) => validators.validateRequired(value);
  String? validateManager(String? value) => validators.validateRequired(value);

  void prepareModelForSave() {
    final currentId = activity.value.id;
    final currentCreatedAt = activity.value.createdAt;

    activity.value = ActivityModel(
      id: currentId,
      title: titleController.text,
      projectId: activity.value.projectId,
      description: descriptionController.text,
      managerId: activity.value.managerId,
      startDate: startDate.value,
      endDate: endDate.value,
      dependencyId: activity.value.dependencyId,
      stateId: activity.value.stateId,
      createdAt: currentCreatedAt,
      updatedAt: DateTime.now(),
    );
  }

  @override
  void resetForm() {
    formKey.currentState?.reset();
    activity.value = ActivityModel(
      projectId: _projectContextService.currentProject?.id ?? 0,
      description: '',
      stateId: 1,
    );
    observationText.value = '';
    _initializeControllers();
  }

  @override
  bool submitForm() {
    if (!_validateForm()) return false;

    try {
      prepareModelForSave();
      _handleSubmit();
      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error al guardar: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  bool _validateForm() {
    if (!formKey.currentState!.validate()) return false;

    if (startDate.value == null) {
      Get.snackbar('Error', 'La fecha de inicio es requerida');
      return false;
    }

    if (activity.value.managerId == null || activity.value.managerId == 0) {
      Get.snackbar('Error', 'El responsable es requerido');
      return false;
    }

    return true;
  }

  Future<bool> _handleSubmit() async {
    try {
      isLoading(true);

      // Save or update the activity
      final savedActivity = activity.value.id > 0
          ? await _activityService.updateActivity(activity.value)
          : await _activityService.createActivity(activity.value);

      if (savedActivity.id > 0) {
        // Save observation if not empty
        if (observationText.value.isNotEmpty) {
          await _saveObservation(savedActivity.id);
        }

        // Upload files if any
        if (files.isNotEmpty) {
          final uploadedFiles =
              await uploadFilesToSupabase(files, savedActivity.id.toString());
          if (uploadedFiles.isNotEmpty) {
            await saveFileReferences(
                uploadedFiles, savedActivity.id, 'activities');
          }
        }

        Get.snackbar(
          'Éxito',
          'Actividad guardada correctamente',
          snackPosition: SnackPosition.BOTTOM,
        );

        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error al guardar la actividad: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading(false);
    }
  }

  Future<void> _saveObservation(int activityId) async {
    try {
      if (_sessionService.currentUser == null) {
        print('No user logged in to save observation');
        return;
      }

      // Format the observation text with bullet points
      final formattedText =
          _observationService.formatObservation(observationText.value);

      // Create the observation model
      final observation = ObservationModel(
        sourceTable: 'activities',
        sourceId: activityId,
        observation: formattedText,
        userId: _sessionService.currentUser!.id,
      );

      // Save to database
      await _observationService.createObservation(observation);
    } catch (e) {
      print('Error saving observation: $e');
    }
  }
}
