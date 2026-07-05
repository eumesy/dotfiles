const vscode = require('vscode');

// .tex を開いたら LaTeX Workshop の Math Preview Panel を自動で開く。
// LaTeX Workshop の起動完了を待つため少し遅延し、開いたパネルは
// .tex エディタの「下」へ移動（右列の PDF プレビューを侵食しないように）、
// 最後にフォーカスをエディタへ戻す。
exports.activate = () => {
  setTimeout(async () => {
    try {
      await vscode.commands.executeCommand('latex-workshop.showMathPreviewPanel');
      // パネルがアクティブになっている場合のみ移動（誤って .tex を動かさない安全弁）
      const active = vscode.window.tabGroups.activeTabGroup.activeTab;
      if (active && active.input instanceof vscode.TabInputWebview) {
        await vscode.commands.executeCommand('workbench.action.moveEditorToFirstGroup');
        await vscode.commands.executeCommand('workbench.action.moveEditorToBelowGroup');
      }
      await vscode.commands.executeCommand('workbench.action.focusFirstEditorGroup');
    } catch { /* LaTeX Workshop 未導入なら何もしない */ }
  }, 2000);
};
exports.deactivate = () => {};
