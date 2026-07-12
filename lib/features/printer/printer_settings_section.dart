import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/printer/bluetooth_printer_device.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/widgets.dart';
import 'printer_controller.dart';

class PrinterSettingsSection extends ConsumerStatefulWidget {
  const PrinterSettingsSection({super.key});

  @override
  ConsumerState<PrinterSettingsSection> createState() =>
      _PrinterSettingsSectionState();
}

class _PrinterSettingsSectionState extends ConsumerState<PrinterSettingsSection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(printerProvider.notifier).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final printer = ref.watch(printerProvider);
    final notifier = ref.read(printerProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionHeader(title: l10n.printer),
        const VGap(AppSpacing.sm),
        AppCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _StatusRow(
                label: l10n.bluetoothStatus,
                value: printer.bluetoothEnabled
                    ? l10n.bluetoothOn
                    : l10n.bluetoothOff,
                icon: printer.bluetoothEnabled
                    ? Icons.bluetooth
                    : Icons.bluetooth_disabled,
              ),
              const VGap(AppSpacing.sm),
              _StatusRow(
                label: l10n.printerConnectionStatus,
                value: printer.isConnecting
                    ? l10n.connecting
                    : printer.isConnected
                        ? l10n.connected
                        : l10n.disconnected,
                icon: printer.isConnected
                    ? Icons.print
                    : Icons.print_disabled_outlined,
              ),
              if (printer.lastError != null) ...[
                const VGap(AppSpacing.sm),
                AppText.body(
                  printer.lastError!,
                  color: context.colors.error,
                ),
              ],
              const VGap(AppSpacing.md),
              AppButton(
                l10n.scanPairedPrinters,
                icon: Icons.refresh,
                loading: printer.isScanning,
                onPressed: printer.isScanning
                    ? null
                    : () => notifier.refreshDevices(),
              ),
              const VGap(AppSpacing.md),
              if (printer.availableDevices.isEmpty)
                AppText.body(
                  l10n.noPairedPrintersPlaceholder,
                  muted: true,
                )
              else
                RadioGroup<String>(
                  groupValue: printer.selectedDevice?.address,
                  onChanged: (value) {
                    if (value == null) return;
                    final device = printer.availableDevices.firstWhere(
                      (entry) => entry.address == value,
                    );
                    notifier.selectDevice(device);
                  },
                  child: Column(
                    children: [
                      for (final device in printer.availableDevices)
                        _DeviceTile(
                          device: device,
                          isSelected:
                              printer.selectedDevice?.address == device.address,
                          onSelected: () => notifier.selectDevice(device),
                        ),
                    ],
                  ),
                ),
              const VGap(AppSpacing.md),
              AppButton(
                l10n.testPrint,
                variant: AppButtonVariant.secondary,
                loading: printer.isPrinting,
                onPressed: printer.selectedDevice == null || printer.isPrinting
                    ? null
                    : () => notifier.testPrint(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: context.tokens.textSecondary),
        const HGap(AppSpacing.sm),
        Expanded(child: AppText.body(label)),
        AppText.body(value, weight: FontWeight.w600),
      ],
    );
  }
}

class _DeviceTile extends StatelessWidget {
  const _DeviceTile({
    required this.device,
    required this.isSelected,
    required this.onSelected,
  });

  final BluetoothPrinterDevice device;
  final bool isSelected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      leading: Radio<String>(
        value: device.address,
        toggleable: false,
      ),
      title: Text(device.name),
      subtitle: Text(device.address),
      selected: isSelected,
      onTap: onSelected,
    );
  }
}
