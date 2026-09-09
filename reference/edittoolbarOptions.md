# Options for editing the toolbar

Customize the edit toolbar for
[`addDrawToolbar`](https://trafficonese.github.io/leaflet.extras/reference/draw.md)

## Usage

``` r
edittoolbarOptions(
  actions = list(save = list(title = "Save changes", text = "Save"), cancel = list(title
    = "Cancel editing, discards all changes", text = "Cancel"), clearAll = list(title =
    "Clear all layers", text = "Clear All")),
  buttons = list(edit = "Edit layers", editDisabled = "No layers to edit", remove =
    "Delete layers", removeDisabled = "No layers to delete")
)
```

## Arguments

- actions:

  List of options for edit action tooltips.

- buttons:

  List of options for edit button tooltips.
