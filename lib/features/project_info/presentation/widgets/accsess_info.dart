import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AccessInfoTile extends StatefulWidget {
  final String title;
  final String value;
  final bool isSecret;

  const AccessInfoTile({
    super.key,
    required this.title,
    required this.value,
    this.isSecret = false,
  });

  @override
  State<AccessInfoTile> createState() => _AccessInfoTileState();
}

class _AccessInfoTileState extends State<AccessInfoTile> {
  bool _hidden = true;

  void _copy() {
    Clipboard.setData(ClipboardData(text: widget.value));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Copied")),
    );
  }

  @override
  Widget build(BuildContext context) {
        final settings = Provider.of<SettingsProvider>(context, listen: false);

    final displayValue = widget.isSecret && _hidden
        ? "**************"
        : widget.value;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color:settings.isDark?AppTheme.white: Colors.grey.withOpacity(0.2)),
      ),
      child: Row(
        children: [
         
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style:  TextStyle(
                    fontWeight: FontWeight.w600,
                    color: settings.isDark?AppTheme.white:AppTheme.black
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  displayValue,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(                    color: settings.isDark?AppTheme.white:AppTheme.black
),
                ),
              ],
            ),
          ),

          Row(
            children: [
              if (widget.isSecret)
                IconButton(
                  icon: Icon(
                                        color: settings.isDark?AppTheme.white:AppTheme.black,

                    _hidden ? Icons.visibility : Icons.visibility_off,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _hidden = !_hidden;
                    });
                  },
                ),

           
              IconButton(
                icon:  Icon(Icons.copy, size: 18,                    color: settings.isDark?AppTheme.white:AppTheme.black
),
                onPressed: _copy,
              ),
            ],
          ),
        ],
      ),
    );
  }
}