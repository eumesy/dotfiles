const vscode = require('vscode');

// .tex を開いたら LaTeX Workshop の Math Preview Panel を自動で開く。
// LaTeX Workshop の起動完了を待つため少し遅延し、開いた後はエディタにフォーカスを戻す。
exports.activate = () => {
  setTimeout(async () => {
    try {
      await vscode.commands.executeCommand('latex-workshop.showMathPreviewPanel');
      await vscode.commands.executeCommand('workbench.action.focusActiveEditorGroup');
    } catch { /* LaTeX Workshop 未導入なら何もしない */ }
  }, 2000);
};
exports.deactivate = () => {};
