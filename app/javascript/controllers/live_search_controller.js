import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static values = {
    itemsSelector: String,
    itemAttribute: String,
    itemToFilter: String
  }

  get totalSearchResultElement() {
    return this.element.querySelector("[data-search-count]");
  }

  get totalRecords() {
    const element = this.element.querySelector("[data-total-count]");
    return element ? parseInt(element.textContent) : 0;
  }

  get rootItemElement() {
    return this.element.querySelector("[data-root]");
  }

  get noResultsElement() {
    return this.element.querySelector(".no-results");
  }

  get formElement() {
    return this.element.querySelector("form");
  }

  get searchInputElement() {
    if (this.formElement)
      return this.formElement.querySelector("input[type='search']");
  }

  get roleSelectElement() {
    if (this.formElement)
      return this.formElement.querySelector("select[name='role']");
  }

  get itemElements() {
    let result = [];

    if (this.itemsSelectorValue)
      result = this.element.querySelectorAll(this.itemsSelectorValue);
    else
      result = this.element.querySelectorAll(".row > div");

    return result || [];
  }

  connect() {
    if (!this.formElement)
      return;
    this.processFilter = this.processFilter.bind(this);

    const divButtons = this.formElement.querySelector(".buttons");
    if (divButtons)
      divButtons.remove();

    if (this.searchInputElement)
      this.searchInputElement.addEventListener("input", this.handleKeyUpInput.bind(this));

    if (this.roleSelectElement)
      this.roleSelectElement.addEventListener("change", this.processFilter);

    this.processFilter();
  }

  handleKeyUpInput = (event) => {
    if (this.handleKeyUpInput.timeout) clearTimeout(this.handleKeyUpInput.timeout);

    this.handleKeyUpInput.timeout = setTimeout(this.processFilter, 300);
  }

  elementHasSearchQuery(element, query) {
    if (!query)
      return true;

    let itemValue = this.itemAttributeValue ? element.getAttribute(this.itemAttributeValue) : element.textContent;
    itemValue = (itemValue || '').toLowerCase();
    return itemValue.includes(query);
  }

  handleSearchResultDisplay(totalResults = 0) {
    if (totalResults === 0) {
      if (this.noResultsElement)
        this.noResultsElement.classList.remove("d-none");
      if (this.rootItemElement)
        this.rootItemElement.classList.add("d-none");
    } else {
      if (this.rootItemElement)
        this.rootItemElement.classList.remove("d-none");
      if (this.noResultsElement)
        this.noResultsElement.classList.add("d-none");
    }

    if (this.totalSearchResultElement)
      this.totalSearchResultElement.textContent = totalResults;
  }

  handleSearchEnd(query, filterRole) {
    this.element.dispatchEvent(new CustomEvent("live-search", {
      detail: { query },
      bubbles: true
    }));

    window.history.replaceState(null, "", `?keyword=${query}&role=${filterRole}`);
  }

  processFilter() {
    const query = (this.searchInputElement?.value || '').toLowerCase();
    const filterRole = this.roleSelectElement?.value || '';
    if (!query && !filterRole) {
      this.handleSearchResultDisplay(this.totalRecords);
      this.handleSearchEnd(query, filterRole);
      return this.itemElements.forEach((element) => element.classList.remove("d-none"));
    }

    let totalResults = 0;
    this.itemElements.forEach((element) => {
      let itemToFilter = [element];
      if (this.itemToFilterValue)
        itemToFilter = [...(element.querySelectorAll(this.itemToFilterValue) || [])];

      let willShow = itemToFilter.some((item) => this.elementHasSearchQuery(item, query));

      if (willShow && filterRole)
        willShow = element.querySelector(`[data-role='${filterRole}']`) !== null;

      if (willShow) {
        element.classList.remove("d-none");
        totalResults++;
      }
      else
        element.classList.add("d-none");
    });

    this.handleSearchResultDisplay(totalResults);

    this.handleSearchEnd(query, filterRole);
  }
}
