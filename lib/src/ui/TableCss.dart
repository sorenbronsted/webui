
part of webui;

class TableCss {
	onSortColumn(TableCellElement th, int direction) {}
	void clearSortColumn(TableCellElement orderBy) {}
	void onEditLinkLabels(AnchorElement a) => a.text = 'E';
	void onDeleteLinkLabels(AnchorElement a) => a.text = 'X';
}
