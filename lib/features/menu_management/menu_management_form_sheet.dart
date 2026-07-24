import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/locator.dart';
import '../../core/formatting/currency_formatter.dart';
import '../../core/network/api_exception.dart';
import '../../core/network/validation_errors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/text_formatting.dart';
import '../../features/menu/widgets/menu_photo.dart';
import '../../features/purchase/data/purchase_image_picker.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/widgets.dart';
import 'data/admin_category_repository.dart';
import 'data/admin_menu_repository.dart';
import 'data/menu_photo_upload.dart';
import 'menu_management_list_controller.dart';
import 'models/admin_category.dart';
import 'models/admin_menu.dart';

/// Shared create/edit form for menu management.
class MenuManagementFormSheet extends ConsumerStatefulWidget {
  const MenuManagementFormSheet({
    super.key,
    this.existing,
    this.onSaved,
  });

  final AdminMenu? existing;
  final VoidCallback? onSaved;

  static Future<bool?> show(
    BuildContext context, {
    AdminMenu? existing,
  }) {
    final width = MediaQuery.sizeOf(context).width;
    final isTablet = width >= 600;

    if (isTablet) {
      return showDialog<bool>(
        context: context,
        builder: (context) => Dialog(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: MenuManagementFormSheet(existing: existing),
          ),
        ),
      );
    }

    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: MenuManagementFormSheet(existing: existing),
      ),
    );
  }

  @override
  ConsumerState<MenuManagementFormSheet> createState() =>
      _MenuManagementFormSheetState();
}

class _MenuManagementFormSheetState
    extends ConsumerState<MenuManagementFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _stockController;
  late final TextEditingController _priceController;

  List<AdminCategory> _categories = const [];
  String? _categoryId;
  String? _photoUrl;
  bool _loadingCategories = true;
  bool _uploadingPhoto = false;
  Map<String, String> _fieldErrors = const {};
  bool _submitting = false;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _titleController = TextEditingController(text: existing?.title ?? '');
    _descriptionController =
        TextEditingController(text: existing?.description ?? '');
    _stockController = TextEditingController(
      text: existing != null ? existing.availableStock.toString() : '',
    );
    _priceController = TextEditingController(
      text: existing != null ? existing.sellPrice.toString() : '',
    );
    _categoryId = existing?.categoryId;
    _photoUrl = existing?.photoUrl;
    _loadCategories();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _stockController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    try {
      final response =
          await locator<AdminCategoryRepository>().fetchCategories();
      if (!mounted) return;
      setState(() {
        _categories = response.items;
        _loadingCategories = false;
        if (_categoryId == null && _categories.isNotEmpty) {
          _categoryId = _categories.first.id;
        }
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingCategories = false);
    }
  }

  Future<void> _pickPhoto() async {
    final file = await locator<PurchaseImagePicker>().pickFromGallery();
    if (file == null || !mounted) return;

    setState(() => _uploadingPhoto = true);

    try {
      final url = await locator<MenuPhotoUpload>().upload(file);
      if (!mounted) return;
      setState(() {
        _photoUrl = url;
        _uploadingPhoto = false;
      });
    } on MenuPhotoValidationException catch (e) {
      if (!mounted) return;
      setState(() => _uploadingPhoto = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _uploadingPhoto = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _uploadingPhoto = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).manageMenusPhotoUploadFailed)),
      );
    }
  }

  AdminMenuRequest _buildRequest() {
    final description = _descriptionController.text.trim();
    if (_isEditing) {
      final existing = widget.existing!;
      return AdminMenuRequest(
        title: toTitleCaseWords(_titleController.text.trim()),
        description: description.isEmpty ? null : description,
        categoryId: _categoryId!,
        photoUrl: _photoUrl,
        availableStock: int.parse(_stockController.text.trim()),
        sellPrice: parseIdrAmount(_priceController.text),
        recipeYield: existing.recipeYield,
        marginPercent: existing.marginPercent,
        vatPercent: existing.vatPercent,
      );
    }

    return AdminMenuRequest(
      title: toTitleCaseWords(_titleController.text.trim()),
      description: description.isEmpty ? null : description,
      categoryId: _categoryId!,
      photoUrl: _photoUrl,
      availableStock: int.parse(_stockController.text.trim()),
      sellPrice: parseIdrAmount(_priceController.text),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_uploadingPhoto) return;

    setState(() {
      _submitting = true;
      _fieldErrors = const {};
    });

    final request = _buildRequest();

    try {
      if (_isEditing) {
        await ref
            .read(menuManagementProvider.notifier)
            .updateMenu(widget.existing!.id, request);
      } else {
        await ref.read(menuManagementProvider.notifier).createMenu(request);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).manageMenusSaved)),
      );
      widget.onSaved?.call();
      Navigator.of(context).pop(true);
    } on ApiException catch (e) {
      if (!mounted) return;
      final fieldErrors = parseApiFieldErrors(e.data);
      setState(() {
        _submitting = false;
        _fieldErrors = fieldErrors;
      });
      _formKey.currentState?.validate();
    } catch (_) {
      if (!mounted) return;
      setState(() => _submitting = false);
    }
  }

  Future<void> _confirmDelete() async {
    final l10n = AppLocalizations.of(context);
    final existing = widget.existing;
    if (existing == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteManageMenu),
        content: Text(l10n.deleteManageMenuConfirm(existing.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _submitting = true);

    try {
      await ref
          .read(menuManagementProvider.notifier)
          .deleteMenu(existing.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.manageMenusDeleted)),
      );
      widget.onSaved?.call();
      Navigator.of(context).pop(true);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.deleteManageMenuFailed)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = _isEditing ? l10n.manageMenusEdit : l10n.manageMenusNew;

    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText.title(title),
            const VGap(AppSpacing.lg),
            _PhotoSection(
              photoUrl: _photoUrl,
              uploading: _uploadingPhoto,
              pickLabel: l10n.manageMenusPickPhoto,
              onPick: _pickPhoto,
            ),
            const VGap(AppSpacing.md),
            AppTextField(
              fieldKey: const Key('menu_management_title_field'),
              label: l10n.stockTitleLabel,
              controller: _titleController,
              textInputAction: TextInputAction.next,
              validator: (value) {
                final apiError = _fieldErrors['title'];
                if (apiError != null) return apiError;
                final trimmed = value?.trim() ?? '';
                if (trimmed.isEmpty) return l10n.fieldRequired;
                return null;
              },
            ),
            const VGap(AppSpacing.md),
            AppTextField(
              fieldKey: const Key('menu_management_description_field'),
              label: l10n.stockDescriptionLabel,
              controller: _descriptionController,
              textInputAction: TextInputAction.next,
              validator: (value) => _fieldErrors['description'],
            ),
            const VGap(AppSpacing.md),
            AppText.label(l10n.manageMenusCategoryLabel),
            const VGap(AppSpacing.xs),
            if (_loadingCategories)
              const LinearProgressIndicator()
            else
              DropdownButtonFormField<String>(
                key: const Key('menu_management_category_field'),
                initialValue: _categoryId,
                decoration: const InputDecoration(),
                items: [
                  for (final category in _categories)
                    DropdownMenuItem(
                      value: category.id,
                      child: Text(category.name),
                    ),
                ],
                onChanged: _submitting
                    ? null
                    : (value) => setState(() => _categoryId = value),
                validator: (value) {
                  final apiError = _fieldErrors['category_id'];
                  if (apiError != null) return apiError;
                  if (value == null || value.isEmpty) {
                    return l10n.manageMenusCategoryRequired;
                  }
                  return null;
                },
              ),
            const VGap(AppSpacing.md),
            AppTextField(
              fieldKey: const Key('menu_management_stock_field'),
              label: l10n.manageMenusStockLabel,
              controller: _stockController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textInputAction: TextInputAction.next,
              validator: (value) {
                final apiError = _fieldErrors['available_stock'];
                if (apiError != null) return apiError;
                final trimmed = value?.trim() ?? '';
                if (trimmed.isEmpty) return l10n.fieldRequired;
                final parsed = int.tryParse(trimmed);
                if (parsed == null || parsed < 0) {
                  return l10n.manageMenusStockInvalid;
                }
                return null;
              },
            ),
            const VGap(AppSpacing.md),
            AppTextField(
              fieldKey: const Key('menu_management_price_field'),
              label: l10n.manageMenusSellPriceLabel,
              controller: _priceController,
              keyboardType: TextInputType.number,
              inputFormatters: [IdrWholeNumberInputFormatter()],
              textInputAction: TextInputAction.done,
              validator: (value) {
                final apiError = _fieldErrors['sell_price'];
                if (apiError != null) return apiError;
                final trimmed = value?.trim() ?? '';
                if (trimmed.isEmpty) return l10n.fieldRequired;
                final parsed = parseIdrAmount(trimmed);
                if (parsed <= 0) return l10n.manageMenusSellPriceInvalid;
                return null;
              },
            ),
            const VGap(AppSpacing.xl),
            AppButton(
              l10n.save,
              key: const Key('menu_management_submit_button'),
              loading: _submitting,
              onPressed: _submitting || _uploadingPhoto ? null : _submit,
            ),
            if (_isEditing) ...[
              const VGap(AppSpacing.md),
              AppButton(
                l10n.delete,
                key: const Key('menu_management_delete_button'),
                variant: AppButtonVariant.secondary,
                loading: _submitting,
                onPressed: _submitting ? null : _confirmDelete,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PhotoSection extends StatelessWidget {
  const _PhotoSection({
    required this.photoUrl,
    required this.uploading,
    required this.pickLabel,
    required this.onPick,
  });

  final String? photoUrl;
  final bool uploading;
  final String pickLabel;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            height: 160,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _NetworkOrAssetPhoto(photoUrl: photoUrl),
                if (uploading)
                  const ColoredBox(
                    color: Color(0x66000000),
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          ),
        ),
        const VGap(AppSpacing.sm),
        OutlinedButton.icon(
          key: const Key('menu_management_pick_photo_button'),
          onPressed: uploading ? null : onPick,
          icon: uploading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.photo_library_outlined),
          label: Text(pickLabel),
        ),
      ],
    );
  }
}

class _NetworkOrAssetPhoto extends StatelessWidget {
  const _NetworkOrAssetPhoto({required this.photoUrl});

  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    return MenuPhoto(photoUrl: photoUrl);
  }
}

/// Routed full-screen wrapper for create/edit flows.
class MenuManagementFormPage extends ConsumerWidget {
  const MenuManagementFormPage({super.key, this.existing});

  final AdminMenu? existing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          existing == null
              ? AppLocalizations.of(context).manageMenusNew
              : AppLocalizations.of(context).manageMenusEdit,
        ),
      ),
      body: MenuManagementFormSheet(
        existing: existing,
        onSaved: () => Navigator.of(context).pop(true),
      ),
    );
  }
}

/// Loads a menu by [id] for the edit route.
class MenuManagementEditPage extends ConsumerStatefulWidget {
  const MenuManagementEditPage({super.key, required this.id});

  final String id;

  @override
  ConsumerState<MenuManagementEditPage> createState() =>
      _MenuManagementEditPageState();
}

class _MenuManagementEditPageState extends ConsumerState<MenuManagementEditPage> {
  AdminMenu? _menu;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final menu =
          await locator<AdminMenuRepository>().fetchMenu(widget.id);
      if (!mounted) return;
      setState(() {
        _menu = menu;
        _loading = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Failed to load menu';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.manageMenusEdit)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null || _menu == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.manageMenusEdit)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText.body(_error ?? 'Not found', align: TextAlign.center),
                const VGap(AppSpacing.lg),
                AppButton(l10n.retry, onPressed: () {
                  setState(() {
                    _loading = true;
                    _error = null;
                  });
                  _load();
                }),
              ],
            ),
          ),
        ),
      );
    }

    return MenuManagementFormPage(existing: _menu);
  }
}
