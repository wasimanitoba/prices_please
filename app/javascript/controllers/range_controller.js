import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    new DateRangePicker(this.element.id, {
      locale: {
        format: "DD-MM-YYYY",
      },
      startDate: moment(),
      endDate: moment().add(7, 'days'),
      ranges: {
        '7 Days': [moment(), moment().add(7, 'days')],
        '10 Days': [ moment(), moment().add(10, 'days')],
        '14 Days': [moment(), moment().add(14, 'days')],
        '21 Days': [moment(), moment().add(21, 'days')]
     },
     autoApply: true,
    });
  }
}
