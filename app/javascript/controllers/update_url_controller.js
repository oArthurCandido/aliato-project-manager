import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    window.history.pushState({}, "", this.data.get("urlValue"));
  }
}
