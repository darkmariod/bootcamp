import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  edit(event) {
    const btn = event.currentTarget
    const row = btn.closest("[data-subscription-id]")
    const form = row.querySelector("[data-edit-form]")
    if (form) form.classList.toggle("hidden")
  }

  cancel(event) {
    const btn = event.currentTarget
    const form = btn.closest("[data-edit-form]")
    if (form) form.classList.add("hidden")
  }
}
