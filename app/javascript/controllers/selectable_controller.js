import { Controller } from "@hotwired/stimulus"
import Selectable from 'selectable.js';

export default class extends Controller {
  static outlets = ['shopping']
  static targets = ['item', 'input']

  update(e) {
    const input = e.currentTarget;
    const item  = input.closest(".item");
    input.checked ? this.selectable.deselect(item) : this.selectable.select(item);
    console.log({item, checked: item.checked, input, e })
  }

  selectAll() {
    for ( const input of this.inputTargets ) {
      this.selectable.select( input.closest(".item") );
    }
  }

  connect() {
    const self      = this;
    self.selectable = new Selectable({
      filter: ".item",
      ignore: ["input", "select", "summary"],
      appendTo: "#items",
      toggle: true
    });

    self.selectable.on("selecteditem", (item) => {
      item.node.querySelector("input").checked = true;
      this.shoppingOutlet.generateShoppingList();
    });

    self.selectable.on("deselecteditem", (item) => {
      item.node.querySelector("input").checked = false;
      this.shoppingOutlet.generateShoppingList();
    });

    self.clear();
  }

  clear() {
    this.selectable.clear();
  }

  itemConnectedCallback(item) {
    this.selectable.add([item]);
  }

  disconnect() {
    this.selectable.destroy();
  }
}
