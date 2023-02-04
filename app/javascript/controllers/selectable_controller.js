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
    this.selectable = new Selectable({
      filter: ".item",
      ignore: ["input", "select", "summary"],
      appendTo: "#items",
      toggle: true
    });

    this.selectable.on("selecteditem", (item) => {
      item.node.querySelector("input").checked = true;

      let hiddenDiv = item.node.querySelector('div.details[hidden]');
      if (hiddenDiv) hiddenDiv.hidden = false;

      this.shoppingOutlet.addToShoppingList(item);
    });

    this.selectable.on("deselecteditem", (item) => {
      item.node.querySelector("input").checked = false;

      let div = item.node.querySelector('div.details:not([hidden])');
      if (div) div.hidden = true;

      this.shoppingOutlet.removeFromShoppingList(item);
    });
  }

  clear() {
    this.selectable.clear();
  }

  itemConnectedCallback(item) {
    this.selectable.add([item]);
    item.closest('input').checked = false;
  }

  disconnect() {
    this.selectable.destroy();
  }
}
