module ApplicationHelper
  # Outline icons from Feather (https://feathericons.com, MIT license).
  ICONS = {
    download: '<path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/>' \
              '<polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/>',
    upload: '<path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/>' \
            '<polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/>',
    plus: '<line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/>'
  }.freeze

  def icon(name)
    tag.svg(
      ICONS.fetch(name).html_safe,
      class: "icon", viewBox: "0 0 24 24", width: 18, height: 18,
      fill: "none", stroke: "currentColor", "stroke-width": 2,
      "stroke-linecap": "round", "stroke-linejoin": "round", "aria-hidden": true
    )
  end

  # A delete button that asks the browser to confirm before submitting.
  # The app does not load Turbo, so data-turbo-confirm would be ignored.
  def delete_button(label, path, confirm:)
    button_to label, path,
              method: :delete,
              form: { onsubmit: "return confirm(#{confirm.to_json});" }
  end
end
