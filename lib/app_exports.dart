// Core exports
export 'core/constants/app_constants.dart';
export 'core/theme/app_theme.dart';
export 'core/utils/validators.dart';
export 'core/services/network_service.dart';
export 'core/services/storage_service.dart';
export 'core/services/auth_service.dart';
export 'core/services/dependency_injection.dart';
export 'core/services/theme_service.dart';

// Domain exports
export 'domain/entities/user.dart';
export 'domain/entities/service_lead.dart';
export 'domain/repositories/user_repository.dart';
export 'domain/repositories/service_lead_repository.dart';
export 'domain/usecases/auth_usecases.dart';
export 'domain/usecases/service_lead_usecases.dart';

// Data exports
export 'data/models/user_model.dart';
export 'data/models/service_lead_model.dart';
export 'data/datasources/user_remote_datasource.dart';
export 'data/datasources/service_lead_remote_datasource.dart';
export 'data/repositories/user_repository_impl.dart';
export 'data/repositories/service_lead_repository_impl.dart';

// Presentation exports
export 'presentation/controllers/login_controller.dart';
export 'presentation/controllers/service_leads_controller.dart';
export 'presentation/screens/login/login_screen.dart';
export 'presentation/screens/dashboard/dashboard_screen.dart';
export 'presentation/screens/dashboard/dashboard_content_pages.dart';
export 'presentation/screens/service_leads/service_leads_page.dart';
export 'presentation/bindings/login_binding.dart';
export 'presentation/bindings/service_leads_binding.dart';

export 'presentation/widgets/custom_button.dart';
export 'presentation/widgets/custom_text_field.dart';
export 'presentation/widgets/common_widgets.dart';

// Routes
export 'routes/app_pages.dart';
export 'routes/app_router.dart';
