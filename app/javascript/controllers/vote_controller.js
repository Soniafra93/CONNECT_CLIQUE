import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["voteButton", "form", "togglableElement", "messageDisplay"]

  fire(event) {
    event.preventDefault();
    this.togglableElementTarget.classList.toggle("d-none");
  }

  handleSuccess(event) {
    const [data, status, xhr] = event.detail;
    this.togglableElementTarget.classList.add("d-none");
    this.voteButtonTarget.classList.add("d-none");
    this.messageDisplayTarget.innerHTML = "Thank you for voting!";
    this.messageDisplayTarget.classList.remove("d-none");
  }

  handleError(event) {
    const [data, status, xhr] = event.detail;
    this.messageDisplayTarget.innerHTML = "There was an error submitting your vote. Please try again.";
    this.messageDisplayTarget.classList.remove("d-none");
  }
}
