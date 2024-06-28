import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="vote"
export default class extends Controller {
  static targets = [
    "form",
    "messageDisplay",
    "voteButton",
    // "votingOptionsContainer",
  ];
  connect() {
    console.log("Hello, Stimulus!", this.element);
  }
  submit(event) {
    event.preventDefault();
    const form = this.formTarget;
    const messageDisplay = this.messageDisplayTarget;
    const voteButton = this.voteButtonTarget;
    // const votingOptionsContainer = this.votingOptionsContainerTarget;

    voteButton.disabled = true;

    fetch(form.action, {
      method: "POST",
      body: new FormData(form),
      headers: {
        "X-Requested-With": "XMLHttpRequest",
        Accept: "application/json",
      },
    })
      .then((response) => {
        if (response.ok) {
          voteButton.classList.add("d-none");
          // votingOptionsContainer.classList.add("d-none");
          console.log("Voting successful");
        }
        return response.json();
      })
      .then((data) => {
        messageDisplay.innerHTML = data.message;
        voteButton.disabled = false;
      })
      .catch((error) => {
        console.error("Error:", error);
        voteButton.disabled = false;
      });
  }
}
