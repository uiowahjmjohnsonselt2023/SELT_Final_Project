describe("DOM Content Loaded event tests", function() {
  var button, form;

  beforeEach(function() {
    // Setup DOM elements
    document.body.innerHTML = `
      <button id="toggleButton">Show Filters</button>
      <form id="dropdownForm" style="display: none;"></form>
    `;

    button = document.getElementById('toggleButton');
    form = document.getElementById('dropdownForm');

    // Trigger your original event listener
    document.dispatchEvent(new Event("DOMContentLoaded"));
  });

  it("should toggle form display and button text on button click", function() {
    // Simulate button click
    button.click();

    // Expectations after first click
    expect(form.style.display).toBe("block");
    expect(button.textContent).toBe("Hide Filters");

    // Simulate button click again
    button.click();

    // Expectations after second click
    expect(form.style.display).toBe("none");
    expect(button.textContent).toBe("Show Filters");
  });
});
