import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["friendsList"];

  toggleFriendSelection(event) {
    if (event.target.value === "select") {
      this.friendsListTarget.classList.remove("d-none");
    } else {
      this.friendsListTarget.classList.add("d-none");
      // Automatically select all friends if 'All Friends' is chosen
      this.selectAllFriends();
    }
  }

  selectAllFriends() {
    const checkboxes = this.friendsListTarget.querySelectorAll("input[type='checkbox']");
    checkboxes.forEach(checkbox => {
      checkbox.checked = true;
    });
  }
}
