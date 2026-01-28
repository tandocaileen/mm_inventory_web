import 'dart:developer';
import 'package:mm_inventory_web/ui/common/app_colors.dart';
import 'package:mm_inventory_web/ui/common/ui_helpers.dart';
import 'package:mm_inventory_web/ui/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:mm_inventory_web/ui/widgets/common/custom_table/custom_data_source.dart';

enum TablePaginationStyle { frontend, backend }

class CustomTable extends StatefulWidget {
  const CustomTable({
    required this.columns,
    required this.data,
    super.key,
    this.rowsPerPage = 10,
    this.pageIndex = 0,
    this.showCheckboxColumn = false,
    this.selectionMode = SelectionMode.none,
    this.onSelectionChanged,
    this.headerRowHeight = 35,
    this.rowHeight = 50,
    this.freezeColumnsCount = 0,
    this.controller,
    this.verticalScrollController,
    this.shrinkWrapRows = true,
    this.shrinkWrapColumns = false,
    this.selectedRowData,
    this.gridLinesVisibility = GridLinesVisibility.horizontal,
    this.headerGridLinesVisibility = GridLinesVisibility.none,
    this.cellBuilder,
    this.totals = const [],
    this.paginationStyle = TablePaginationStyle.frontend,
    this.onPageChanged,
    this.totalRowCount,
    this.autoSizeColumns = false,
    this.showSearchField = true,
    this.searchHint = 'Search...',
    this.onSearchChanged,
    this.expandToFillSpace = false,
    this.uniqueIdColumn,
  });

  final List<String> columns;
  final List<Map<String, dynamic>> data;
  final int rowsPerPage;
  final int pageIndex;
  final bool showCheckboxColumn;
  final SelectionMode selectionMode;
  final void Function(List<DataGridRow>, List<DataGridRow>)? onSelectionChanged;
  final double headerRowHeight;
  final double rowHeight;
  final int freezeColumnsCount;
  final DataGridController? controller;
  final ScrollController? verticalScrollController;
  final bool shrinkWrapRows;
  final bool shrinkWrapColumns;
  final GridLinesVisibility gridLinesVisibility;
  final GridLinesVisibility headerGridLinesVisibility;
  final void Function(List<Map<String, dynamic>>?)? selectedRowData;

  /// Accepts a builder for custom cell widgets.
  /// (row, columnName, value) => Widget
  final Widget Function(Map<String, dynamic> row, String column, dynamic value)?
      cellBuilder;

  /// Example:
  /// [
  ///   {"Amount": "1234.56"},
  ///   {"Price": "987.65"}
  /// ]
  final List<Map<String, String>> totals;

  /// Pagination style: Frontend (default) or Backend
  final TablePaginationStyle paginationStyle;

  /// Called when page changes (only for Backend pagination)
  final void Function(int pageIndex, int rowsPerPage)? onPageChanged;

  /// Used for Backend pagination to show correct total pages
  final int? totalRowCount;

  /// When true, columns will automatically expand based on cell content.
  /// When false, columns will use fill mode (equal distribution).
  /// Default is true for better content visibility.
  final bool autoSizeColumns;

  /// When true, shows a search field above the table for filtering data.
  /// Default is false.
  final bool showSearchField;

  /// Placeholder text for the search field.
  /// Default is 'Search...'.
  final String searchHint;

  /// Callback when search text changes.
  /// Receives the current search query string.
  final void Function(String)? onSearchChanged;

  /// When true, the table expands to fill all available space in its container.
  /// When false, the table size is determined by its content.
  /// Default is false.
  final bool expandToFillSpace;

  /// The column name to use as the unique identifier for each row.
  /// If not provided, the first entry in the row map will be used.
  final String? uniqueIdColumn;

  @override
  State<CustomTable> createState() => _CustomTableState();
}

class _CustomTableState extends State<CustomTable>
    with AutomaticKeepAliveClientMixin {
  late CustomDataSource _dataSource;
  int _rowsPerPage = 10;
  int _pageIndex = 0;
  List<Map<String, dynamic>> _lastPagedData = [];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Tracks selected row unique IDs (from first field of tableData)
  final Set<dynamic> _selectedRowIds = {};

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _rowsPerPage = widget.rowsPerPage;
    _pageIndex = widget.pageIndex;

    final pagedData = _getPagedData(widget.data);
    _dataSource = _createDataSource(pagedData);
    _lastPagedData = List.from(pagedData);
    _restoreSelectionToController();
  }

  @override
  void didUpdateWidget(covariant CustomTable oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.data != widget.data || oldWidget.columns != widget.columns) {
      final pagedData = _getPagedData(widget.data);
      if (!listEquals(pagedData, _lastPagedData)) {
        _dataSource = _createDataSource(pagedData);
        _lastPagedData = List.from(pagedData);
        _restoreSelectionToController();
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _getPagedData(
    List<Map<String, dynamic>> fullData,
  ) {
    // Apply search filter first
    var filteredData = fullData;
    if (widget.showSearchField && _searchQuery.isNotEmpty) {
      filteredData = _filterData(fullData, _searchQuery);
    }

    if (widget.paginationStyle == TablePaginationStyle.backend) {
      // Backend: data is already paged, just return as is
      return filteredData;
    }
    // Frontend: slice data for current page
    final int totalRows = filteredData.length;
    final int startRow = _pageIndex * _rowsPerPage;
    final int endRow = (startRow + _rowsPerPage).clamp(0, totalRows);
    return filteredData.sublist(startRow, endRow);
  }

  List<Map<String, dynamic>> _filterData(
    List<Map<String, dynamic>> data,
    String query,
  ) {
    final lowercaseQuery = query.toLowerCase();
    return data.where((row) {
      // Search through all column values
      return row.values.any((value) {
        if (value == null) return false;
        return value.toString().toLowerCase().contains(lowercaseQuery);
      });
    }).toList();
  }

  /// Creates a new CustomDataSource with the current configuration
  CustomDataSource _createDataSource(List<Map<String, dynamic>> data) {
    return CustomDataSource(
      columns: widget.columns,
      data: data,
      cellBuilder: widget.cellBuilder,
      showEmptyRow:
          widget.showSearchField && _searchQuery.isNotEmpty && data.isEmpty,
      emptyRowMessage: 'Nothing found...',
      uniqueIdColumn: widget.uniqueIdColumn,
    );
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _pageIndex = 0; // Reset to first page when search changes
      final pagedData = _getPagedData(widget.data);

      // Update data source with empty row flag
      _dataSource = _createDataSource(pagedData);
      _lastPagedData = List.from(pagedData);
    });

    // Still call the callback if provided
    widget.onSearchChanged?.call(query);
  }

  void _onPageChanged(int pageIndex) {
    setState(() {
      _pageIndex = pageIndex;
      log('Page changed to $_pageIndex');
      if (widget.paginationStyle == TablePaginationStyle.backend) {
        widget.onPageChanged?.call(_pageIndex, _rowsPerPage);
      } else {
        final pagedData = _getPagedData(widget.data);
        if (!listEquals(pagedData, _lastPagedData)) {
          _dataSource = _createDataSource(pagedData);
          _lastPagedData = List.from(pagedData);
          _restoreSelectionToController();
        }
      }
    });
  }

  void _handleSelectionChanged(
    List<DataGridRow> addedRows,
    List<DataGridRow> removedRows,
  ) {
    // Use the first field value as unique ID, not first column
    for (final row in addedRows) {
      final uniqueId = _dataSource.getUniqueIdForRow(row);
      if (uniqueId != null) {
        _selectedRowIds.add(uniqueId);
      }
    }

    for (final row in removedRows) {
      final uniqueId = _dataSource.getUniqueIdForRow(row);
      if (uniqueId != null) _selectedRowIds.remove(uniqueId);
    }

    // Always call selectedRowData after selection changes
    widget.selectedRowData?.call(getSelectedRowsJson());

    widget.onSelectionChanged?.call(addedRows, removedRows);
  }

  void _restoreSelectionToController() {
    if (widget.controller == null) return;

    final selectedRows = _dataSource.rows.where((row) {
      final uniqueId = _dataSource.getUniqueIdForRow(row);
      return uniqueId != null && _selectedRowIds.contains(uniqueId);
    }).toList();

    widget.controller!.selectedRows = selectedRows;
  }

  /// Returns a list of JSON maps for the currently selected rows.

  List<Map<String, dynamic>> getSelectedRowsJson() {
    return widget.data.where((row) {
      final uniqueId = row.entries.first.value;
      return _selectedRowIds.contains(uniqueId);
    }).toList();
  }

  /// Determines the appropriate column width mode based on device type and configuration
  ColumnWidthMode _getColumnWidthMode() {
    final deviceType = getDeviceType(MediaQuery.of(context).size);

    // Mobile devices always use auto mode for better responsiveness
    if (deviceType == DeviceScreenType.mobile) {
      return ColumnWidthMode.auto;
    }

    // For desktop/tablet, use fitByCellValue when autoSizeColumns is enabled
    // Otherwise use fill mode for equal distribution
    return widget.autoSizeColumns
        ? ColumnWidthMode.fitByCellValue
        : ColumnWidthMode.fill;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Apply search filter to get actual data count
    var dataToCount = widget.data;
    if (widget.showSearchField && _searchQuery.isNotEmpty) {
      dataToCount = _filterData(widget.data, _searchQuery);
    }

    // Use totalRowCount for Backend, otherwise use filtered data length
    final int totalRows = widget.paginationStyle == TablePaginationStyle.backend
        ? (widget.totalRowCount!)
        : dataToCount.length;
    final int totalPages = (totalRows / _rowsPerPage).ceil();
    // log('Total Rows: $totalRows, Total Pages: $totalPages');
    // log('selectedRowIds: $_selectedRowIds');

    if (widget.data.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inbox, size: 48, color: kcMediumGrey),
            verticalSpaceSmall,
            Text(
              'No data to display.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: kcMediumGrey),
            ),
          ],
        ),
      );
    }

    final tableContent = Column(
      mainAxisSize:
          widget.expandToFillSpace ? MainAxisSize.max : MainAxisSize.min,
      children: [
        // Search field
        if (widget.showSearchField)
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: widget.searchHint,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
              ),
            ),
          ),

        // Table Card
        if (widget.expandToFillSpace)
          Expanded(child: _buildTableCard(context))
        else
          _buildTableCard(context),

        //Totals
        if (widget.totals.isNotEmpty &&
            (getDeviceType(MediaQuery.of(context).size) !=
                DeviceScreenType.mobile))
          verticalSpaceMedium,
        if (widget.totals.isNotEmpty &&
            (getDeviceType(MediaQuery.of(context).size) !=
                DeviceScreenType.mobile))
          Row(
            children: widget.columns.asMap().entries.map((entry) {
              final index = entry.key;
              final col = entry.value;

              final match = widget.totals.firstWhere(
                (t) => t.containsKey(col),
                orElse: () => {},
              );

              if (match.isEmpty) {
                if (index == widget.columns.length - 1 &&
                    col.toLowerCase() == 'action') {
                  return const SizedBox(width: 100);
                }
                return const Expanded(child: SizedBox());
              }

              // If it's the last column and TableColumns.action, subtract 100 from available width
              if (index == widget.columns.length - 1 &&
                  col.toLowerCase() == 'action') {
                return TotalBox(
                  label: col,
                  value: double.tryParse(match[col]!) ?? 0,
                  color: kcPrimaryColor,
                );
              }

              return Expanded(
                child: TotalBox(
                  label: col,
                  value: double.tryParse(match[col]!) ?? 0,
                  color: kcPrimaryColor,
                ),
              );
            }).toList(),
          ),

        if (totalPages > 1)
          SizedBox(
            height: 56,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.first_page),
                  onPressed: _pageIndex > 0 ? () => _onPageChanged(0) : null,
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: _pageIndex > 0
                      ? () => _onPageChanged(_pageIndex - 1)
                      : null,
                ),
                Text('Page ${_pageIndex + 1} of $totalPages'),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: _pageIndex < totalPages - 1
                      ? () => _onPageChanged(_pageIndex + 1)
                      : null,
                ),
                IconButton(
                  icon: const Icon(Icons.last_page),
                  onPressed: _pageIndex < totalPages - 1
                      ? () => _onPageChanged(totalPages - 1)
                      : null,
                ),
              ],
            ),
          ),
      ],
    );

    return tableContent;
  }

  Widget _buildTableCard(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.hardEdge,
      child: SfDataGridTheme(
        data: TAppTheme.dataGridTheme,
        child: SfDataGrid(
          columnWidthMode: _getColumnWidthMode(),
          shrinkWrapRows: widget.shrinkWrapRows,
          shrinkWrapColumns: widget.shrinkWrapColumns,
          controller: widget.controller,
          source: _dataSource,
          columns: widget.columns
              .map(
                (col) => GridColumn(
                  columnName: col,
                  width: col.toLowerCase() == 'action' ? 100 : double.nan,
                  allowSorting: col.toLowerCase() != 'action',
                  label: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      col,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                      overflow: TextOverflow.visible,
                      softWrap: true,
                      maxLines: 2,
                    ),
                  ),
                ),
              )
              .toList(),
          allowSorting: true,
          showCheckboxColumn: widget.showCheckboxColumn,
          isScrollbarAlwaysShown: true,
          selectionMode: widget.selectionMode,
          onSelectionChanged: _handleSelectionChanged,
          headerRowHeight: widget.headerRowHeight,
          rowHeight: widget.rowHeight < 40 ? 40 : widget.rowHeight,
          frozenColumnsCount: widget.freezeColumnsCount,
          verticalScrollController: widget.verticalScrollController,
          gridLinesVisibility: widget.gridLinesVisibility,
          headerGridLinesVisibility: widget.headerGridLinesVisibility,
        ),
      ),
    );
  }
}

class TotalBox extends StatelessWidget {
  const TotalBox({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: color.withAlpha(75)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
          ),
          Text(
            value.toStringAsFixed(2),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
          ),
        ],
      ),
    );
  }
}
