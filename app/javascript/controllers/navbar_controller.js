// app/javascript/controllers/navbar_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.lastScrollTop = 0;
    this.initializeNavbar();
    this.bindScrollEvent();
  }

  disconnect() {
    window.removeEventListener("scroll", this.handleScroll);
  }

  initializeNavbar() {
    this.element.style.position = "fixed";
    this.element.style.width = "100%";
    this.element.style.top = "0";
    this.element.style.zIndex = "1000";
  }

  bindScrollEvent() {
    this.handleScroll = this.handleScroll.bind(this);
    window.addEventListener("scroll", this.handleScroll);
  }

  handleScroll() {
    const currentScroll = window.pageYOffset || document.documentElement.scrollTop;

    if (currentScroll <= 0) {
      this.element.style.transition = "transform 0.3s ease-in-out";
      this.element.style.transform = "translateY(0)";
    } else if (currentScroll > this.lastScrollTop) {
      this.element.style.transition = "transform 0.3s ease-in-out";
      this.element.style.transform = "translateY(-100%)";
    } else {
      this.element.style.transition = "transform 0.3s ease-in-out";
      this.element.style.transform = "translateY(0)";
    }

    this.lastScrollTop = currentScroll;
  }
}
