// app/javascript/controllers/tom_select_controller.js
import { Controller } from "@hotwired/stimulus";
import TomSelect from "tom-select";

export default class extends Controller {
  connect() {
    console.log("TomSelect controller connected");
    new TomSelect(this.element, {
      render: {
        option: (data, escape) => {
          console.log("Rendering option:", data);
          return this.renderOption(data, escape);
        },
        item: (data, escape) => {
          console.log("Rendering item:", data);
          return this.renderItem(data, escape);
        },
      },
    });
  }

  renderOption(data, escape) {
    console.log("Avatar URL:", data.dataset.avatar);
    return `<div>
      <img src="${data.dataset.avatar}" alt="" class="avatar-image friends-avatar me-2">
      <span>${escape(data.text)}</span>
    </div>`;
  }

  renderItem(data, escape) {
    console.log("Avatar URL:", data.dataset.avatar);
    return `<div>
      <img src="${data.dataset.avatar}" alt="" class="avatar-image friends-avatar me-2">
      <span>${escape(data.text)}</span>
    </div>`;
  }
}
