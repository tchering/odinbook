import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="mdb"

export default class extends Controller {
  connect() {
    this.initializeDropdowns();
    console.log("Mdb controller is working");
  }

  initializeDropdowns() {
    // Reinitialize all MDBootstrap dropdowns
    const dropdownElements = document.querySelectorAll(".dropdown-toggle");
    dropdownElements.forEach((dropdown) => {
      new mdb.Dropdown(dropdown); // Specific to MDBootstrap
    });
  }
}
