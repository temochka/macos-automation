const rootNode = dv.el("div", "");
dv.container = rootNode;

const goals = dv.pages('"Me/360"');
const maxCheckins = [...goals].reduce((a, {checkins}) => (checkins.length > a ? checkins.length : a), 0);

dv.table(
  ["360° Goal", ...Array(maxCheckins)],
  goals.map(({file, checkins}) =>  {
    return [
      file.link,
      ...checkins.map(({ icon, label, field }) => {
        return [
          dv.el("label", icon, { attr: {title: label}}),
          dv.el("input", "", { cls: "habit-punchhole", attr: { type: "checkbox", "data-field": field}})
        ];
      }),
      ...Array(Math.max(0, maxCheckins - checkins.length)).fill("")
    ];
  })
)

const checkboxes = rootNode.querySelectorAll('.habit-punchhole');
// const { update, createYamlProperty } = this.app.plugins.plugins["metaedit"].api;

const properties = this.app.internalPlugins.getEnabledPluginById("properties");
const currentView = this.app.workspace.activeLeaf.view;

for (const checkbox of checkboxes) {
  checkbox.checked = dv.current()[checkbox.dataset.field];
  checkbox.addEventListener("change", async () => {
    const metadataEditor = currentView.metadataEditor;
    if (!metadataEditor) return;
    
    var metadata = metadataEditor.serialize();
    metadata[checkbox.dataset.field] = checkbox.checked ? true : false;
    metadataEditor.synchronize(metadata);
    metadataEditor.save();

    // if (dv.current()[checkbox.dataset.field] !== undefined) {
      
    //   await update(checkbox.dataset.field, checkbox.checked, dv.current().file.path);
    // } else {
    //   await createYamlProperty(checkbox.dataset.field, "true", dv.current().file.path);
    // }
  });
}
