import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:mm_inventory_web/ui/common/app_colors.dart';

class CustomDataSource extends DataGridSource {
  CustomDataSource({
    required this.columns,
    required List<Map<String, dynamic>> data,
    this.cellBuilder,
    this.showEmptyRow = false,
    this.emptyRowMessage = 'Nothing found...',
    this.uniqueIdColumn,
  }) : _data = data {
    _buildRows();
  }

  final List<String> columns;
  final Widget Function(Map<String, dynamic> row, String column, dynamic value)?
      cellBuilder;
  final bool showEmptyRow;
  final String emptyRowMessage;
  final String? uniqueIdColumn;

  List<Map<String, dynamic>> _data;
  List<DataGridRow> _rows = [];

  // Store mapping of DataGridRow to their unique IDs
  final Map<DataGridRow, dynamic> _rowToUniqueId = {};

  // Cache for O(1) lookup of row data by unique ID
  final Map<dynamic, Map<String, dynamic>> _uniqueIdToRowData = {};

  @override
  List<DataGridRow> get rows => _rows;

  void updateData(List<Map<String, dynamic>> data) {
    _data = data;
    _buildRows();
    notifyListeners();
  }

  void _buildRows() {
    _rowToUniqueId.clear();
    _uniqueIdToRowData.clear();

    if (_data.isEmpty && showEmptyRow) {
      final emptyDataGridRow = DataGridRow(
        cells: columns
            .map((col) => DataGridCell<dynamic>(columnName: col, value: null))
            .toList(),
      );
      _rows = [emptyDataGridRow];
      return;
    }

    _rows = _data.map((row) {
      final uniqueId = uniqueIdColumn != null && row.containsKey(uniqueIdColumn)
          ? row[uniqueIdColumn]
          : row.entries.first.value;

      final dataGridRow = DataGridRow(
        cells: columns
            .map(
              (col) => DataGridCell<dynamic>(columnName: col, value: row[col]),
            )
            .toList(),
      );

      _rowToUniqueId[dataGridRow] = uniqueId;
      _uniqueIdToRowData[uniqueId] = row;

      return dataGridRow;
    }).toList();
  }

  // Get unique ID for a row
  dynamic getUniqueIdForRow(DataGridRow row) {
    return _rowToUniqueId[row];
  }

  // Get data row for a unique ID - uses O(1) cached lookup
  Map<String, dynamic>? getDataForUniqueId(dynamic uniqueId) {
    return _uniqueIdToRowData[uniqueId];
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    // Check if this is the empty placeholder row
    final isEmptyRow =
        _data.isEmpty && showEmptyRow && _rows.isNotEmpty && row == _rows.first;

    if (isEmptyRow) {
      // Return a single cell spanning all columns with the empty message
      // Note: Syncfusion DataGrid requires the same number of cells as columns,
      // so we create one cell with the message and empty containers for the rest
      return DataGridRowAdapter(
        color: kcBackgroundColor,
        cells: [
          // First cell contains the message
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              emptyRowMessage,
              style: const TextStyle(
                fontSize: 14,
                color: kcMediumGrey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          // Remaining cells are empty containers (required by Syncfusion DataGrid)
          ...List.generate(columns.length - 1, (_) => Container()),
        ],
      );
    }

    // Use cached mapping for O(1) lookup instead of linear search
    final uniqueId = _rowToUniqueId[row];
    final Map<String, dynamic>? rowData = _uniqueIdToRowData[uniqueId];

    // Fallback to empty map if not found (shouldn't happen in normal operation)
    final effectiveRowData = rowData ?? {};

    const Color rowColor = kcVeryLightGrey;

    return DataGridRowAdapter(
      color: rowColor,
      cells: row.getCells().map((cell) {
        // Use cellBuilder for any non-String values when cellBuilder is provided.
        // This allows custom rendering for widgets, icons, buttons, etc.
        // The condition checks if value is NOT a String instance (e.g., Widget, Icon, int, etc.)
        if (cellBuilder != null && cell.value is! String) {
          return cellBuilder!(effectiveRowData, cell.columnName, cell.value);
        }

        // Default text rendering for String values and when no cellBuilder is provided
        return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            cell.value?.toString() ?? '',
            style: const TextStyle(fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
    );
  }

  Future<void> handleSort(
    String columnName,
    DataGridSortDirection direction,
  ) async {
    // Perform sorting on the data
    _data.sort((a, b) {
      final aValue = a[columnName];
      final bValue = b[columnName];

      // Handle null values
      if (aValue == null && bValue == null) return 0;
      if (aValue == null) {
        return direction == DataGridSortDirection.ascending ? -1 : 1;
      }
      if (bValue == null) {
        return direction == DataGridSortDirection.ascending ? 1 : -1;
      }

      // Handle numeric values
      if (aValue is num && bValue is num) {
        return direction == DataGridSortDirection.ascending
            ? aValue.compareTo(bValue)
            : bValue.compareTo(aValue);
      }

      // Handle string comparison (case-insensitive)
      final aString = aValue.toString().toLowerCase();
      final bString = bValue.toString().toLowerCase();

      return direction == DataGridSortDirection.ascending
          ? aString.compareTo(bString)
          : bString.compareTo(aString);
    });

    // Rebuild rows after sorting
    _buildRows();
    notifyListeners();
  }
}
