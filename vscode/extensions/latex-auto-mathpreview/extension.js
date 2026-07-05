const vscode = require('vscode');

// .tex を開いたら LaTeX Workshop の Math Preview Panel を自動で開き、
// 以下のレイアウトを維持する（PDF ビューアが後から開いたときも組み直す）:
// ┌─────────────┬──────────┐
// │  main.tex   │          │
// ├─────────────┤  PDF     │
// │ Math Preview│          │
// └─────────────┴──────────┘
// 実現方法: いったん全グループを 1 つに統合 → PDF を右へ分割 → Math Preview を下へ分割。
// 注意: 組み直しの際、このウィンドウ内の他の手動ペイン分割も統合される。

const cmd = (c, ...args) => vscode.commands.executeCommand(c, ...args);
const FOCUS_GROUP = [
  'workbench.action.focusFirstEditorGroup',
  'workbench.action.focusSecondEditorGroup',
  'workbench.action.focusThirdEditorGroup',
  'workbench.action.focusFourthEditorGroup',
];

function findTab(labelRe) {
  for (const g of vscode.window.tabGroups.all)
    for (const t of g.tabs)
      if (t.input instanceof vscode.TabInputWebview && labelRe.test(t.label)) return t;
  return null;
}

// 指定タブをアクティブにする（グループへフォーカス → グループ内インデックスで選択）
async function activateTab(labelRe) {
  const tab = findTab(labelRe);
  if (!tab) return false;
  const gi = vscode.window.tabGroups.all.indexOf(tab.group);
  if (gi < 0 || gi >= FOCUS_GROUP.length) return false;
  await cmd(FOCUS_GROUP[gi]);
  await cmd('workbench.action.openEditorAtIndex', tab.group.tabs.indexOf(tab));
  return true;
}

let arranging = false;
async function arrange() {
  if (arranging) return;
  arranging = true;
  try {
    if (!findTab(/math preview/i)) return;
    await cmd('workbench.action.joinAllGroups');
    if (await activateTab(/\.pdf$/i)) await cmd('workbench.action.moveEditorToRightGroup');
    if (await activateTab(/math preview/i)) await cmd('workbench.action.moveEditorToBelowGroup');
    await cmd('workbench.action.focusFirstEditorGroup');
  } finally {
    arranging = false;
  }
}

exports.activate = (ctx) => {
  // LaTeX Workshop の起動完了を待って Math Preview Panel を開く
  setTimeout(async () => {
    try {
      await cmd('latex-workshop.showMathPreviewPanel');
      await arrange();
    } catch { /* LaTeX Workshop 未導入なら何もしない */ }
  }, 2000);

  // PDF ビューア / Math Preview が後から開かれたときもレイアウトを組み直す
  ctx.subscriptions.push(vscode.window.tabGroups.onDidChangeTabs((e) => {
    if (arranging) return;
    const opened = e.opened.some((t) => t.input instanceof vscode.TabInputWebview && (/\.pdf$/i.test(t.label) || /math preview/i.test(t.label)));
    if (opened) setTimeout(() => arrange().catch(() => {}), 300);
  }));
};
exports.deactivate = () => {};
