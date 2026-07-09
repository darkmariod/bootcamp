import { Controller } from "@hotwired/stimulus"

// Resets a form after a successful Turbo submission
export default class extends Controller {
  reset(event) {
    if (event.detail.success) {
      this.element.reset()
    }
  }
}
