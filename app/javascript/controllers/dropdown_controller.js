// app/javascript/controllers/dropdown_controller.js
import { Controller } from "@hotwired/stimulus"
import { Dropdown } from 'mdb-ui-kit'

export default class extends Controller {
  connect() {
    // Initialize dropdown when controller connects
    this.dropdown = new Dropdown(this.element)
  }

  disconnect() {
    // Clean up when controller disconnects
    if (this.dropdown) {
      this.dropdown.dispose()
    }
  }
}