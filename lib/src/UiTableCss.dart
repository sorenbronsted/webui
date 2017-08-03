
part of webui;

class UiTableCss {
	onSortColumn(TableCellElement th, int direction) {}
	void clearSortColumn(TableCellElement orderBy) {}
	void onEditLinkLabels(AnchorElement a) => a.text = 'E';
	void onDeleteLinkLabels(AnchorElement a) => a.text = 'X';
}
