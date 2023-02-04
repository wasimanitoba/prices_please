import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static outlets = [ "selectable"]
  static targets = [ "form", "package", "errand", "addButton" ]

  selection = {}

  all() {
    this.selectableOutlet.selectAll();
  }

  clear() {
    this.selectableOutlet.clear();
  }

  removeFromShoppingList(item) {
    console.log(item, this.errandTargets.length);
  }

  addToShoppingList(item) {
    this.addButtonTarget.click();
    let addedItemTarget = this.errandTargets[this.errandTargets.length - 1]
    addedItemTarget.scrollIntoView();
    addedItemTarget.querySelector('select').value = item.node.querySelector('select').value;
    addedItemTarget.querySelector('input').value  = item.node.querySelector('input#quantity').value;
  }

  gather() {
    if (this.hasSelectableOutlet) {
      let selectedPackages       = this.selectableOutlet.selectable.getSelectedItems();
      this.selection['packages'] = {};
      this.selection['items']    = {};

      selectedPackages.map((i) => {
        let value    = i.node.querySelector('select').value;
        let quantity = (Number)(i.node.querySelector('input#quantity').value);

        if (value) { this.selection['packages'][value]  = quantity + (this.selection['packages'][value]  || 0); }
        else       { this.selection['items'][i.node.id] = quantity + (this.selection['items'][i.node.id] || 0); }
      });
    }
  }

  generateShoppingList() {
    this.gather();

    let form  = this.formTarget;
    let items = JSON.stringify(this.selection['items']);
    let pkg   = JSON.stringify(this.selection['packages']);

    let checkoutParams = new URLSearchParams({ pkg, items })
    form.action = `/checkout/?${checkoutParams}`;

    console.log(this.hasSelectableOutlet, form, items, pkg, checkoutParams);

    return { items, pkg, checkoutParams };
  }
}
